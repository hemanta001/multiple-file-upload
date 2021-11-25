

import grails.converters.XML
import grails.validation.ValidationException
import grails.rest.*
import grails.web.http.HttpHeaders
import org.w3c.dom.Attr
import org.w3c.dom.Element

import javax.xml.parsers.DocumentBuilder
import javax.xml.parsers.DocumentBuilderFactory
import javax.xml.transform.Transformer
import javax.xml.transform.TransformerFactory
import javax.xml.transform.dom.DOMSource
import javax.xml.transform.stream.StreamResult

import static org.springframework.http.HttpStatus.*
//import org.apache.commons.httpclient.methods.PostMethod

class TxnController {
    //GrailsApplication grailsApplication = ApplicationHolder.application
    def txnService

    String sipId = grailsApplication.config.getProperty('sip.id');
    String sipAccessKey = grailsApplication.config.getProperty('sip.access-key');
    String responseUrl = grailsApplication.config.getProperty('url.sip.responseUrl');
    String redirectUrl = grailsApplication.config.getProperty('url.sip.redirectUrl');
    String initiateRequest = grailsApplication.config.getProperty('url.emdha.initiateRequest');
    String checkStatus = grailsApplication.config.getProperty('url.emdha.checkStatus');
    String maxWaitPeriod = grailsApplication.config.getProperty('sip.maxWaitPeriod');
    String assuranceLevel = grailsApplication.config.getProperty('sip.assuranceLevel');

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond txnService.list(params), model: [txnCount: txnService.count()]
    }

    def show(Long id) {
        respond txnService.get(id)
    }

    def create() {
        respond new Txn(params)
    }

    def initiateRequest(Long id) {
       Txn t = txnService.get(id)

        [xmlvalue: generateXML(t)]
    }

    def checkStatus() {
        String xml = "";
    }

    def save(Txn txn) {
        if (txn == null) {
            notFound()
            return
        }

        try {
           //String xmlValue = generateXML(txn)
            txnService.save(txn)
            //respond xmlService.generateXML()
        } catch (ValidationException e) {
            respond txn.errors, view: 'create'
            return
        }

        //render view:'initiateRequest', model:[id: txn.id, xmlValue: xmlValue]
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'txn.label', default: 'Txn'), txn.id])
                redirect txn
            }
            '*' { respond txn, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond txnService.get(id)
    }

    def update(Txn txn) {
        if (txn == null) {
            notFound()
            return
        }

        try {
            txnService.save(txn)
        } catch (ValidationException e) {
            respond txn.errors, view: 'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'txn.label', default: 'Txn'), txn.id])
                redirect txn
            }
            '*' { respond txn, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        txnService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'txn.label', default: 'Txn'), id])
                redirect action: "index", method: "GET"
            }
            '*' { render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'txn.label', default: 'Txn'), params.id])
                redirect action: "index", method: "GET"
            }
            '*' { render status: NOT_FOUND }
        }
    }

    def generateXML(Txn txn){
        String txnDate = txn.dateCreated.toString().replace(' ','T').takeBefore('.');
        String sipAccessKeyStr = txn.txnId + txnDate + sipAccessKey;
        String sipAccessKeyHash = sipAccessKeyStr.digest('SHA-256')
        DocumentBuilderFactory documentFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder documentBuilder = documentFactory.newDocumentBuilder();
        org.w3c.dom.Document xmlDoc = documentBuilder.newDocument();

        // root element
        Element root = xmlDoc.createElement("SignReq");
        xmlDoc.appendChild(root);
        Element docs = xmlDoc.createElement("docs");
        root.appendChild(docs);

        Attr ver = xmlDoc.createAttribute("version");
        ver.setValue("1.00");
        root.setAttributeNode(ver);

        Attr ts = xmlDoc.createAttribute("ts");
        ts.setValue(txnDate);
        root.setAttributeNode(ts);

        Attr txnx = xmlDoc.createAttribute("txn");
        txnx.setValue(txn.txnId);
        root.setAttributeNode(txnx);

        Attr sipIdx = xmlDoc.createAttribute("sipId");
        sipIdx.setValue(sipId);
        root.setAttributeNode(sipIdx);

        Attr sipAccessKeyHashx = xmlDoc.createAttribute("sipAccessKeyHash");
        sipAccessKeyHashx.setValue(sipAccessKeyHash);
        root.setAttributeNode(sipAccessKeyHashx);

        Attr transactionType = xmlDoc.createAttribute("transactionType");
        transactionType.setValue(txn.txnType.toString()); //txn.hashDoc
        root.setAttributeNode(transactionType);

        Attr assuranceLevelx = xmlDoc.createAttribute("assuranceLevel");
        assuranceLevelx.setValue(assuranceLevel);
        root.setAttributeNode(assuranceLevelx);

        Attr languageId = xmlDoc.createAttribute("languageId");
        languageId.setValue("en");
        root.setAttributeNode(languageId);

        Attr notifyUser = xmlDoc.createAttribute("notifyUser");
        notifyUser.setValue(txn.notifyUser.toString());
        root.setAttributeNode(notifyUser);

        Attr signerNationalId = xmlDoc.createAttribute("signerNationalId");
        signerNationalId.setValue(txn.signer.NID);
        root.setAttributeNode(signerNationalId);

        Attr notificationEmail = xmlDoc.createAttribute("notificationEmail");
        notificationEmail.setValue(txn.signer.email);
        root.setAttributeNode(notificationEmail);

        Attr redirectUrlx = xmlDoc.createAttribute("redirectURL");
        redirectUrlx.setValue(redirectUrl);
        root.setAttributeNode(redirectUrlx);

        Attr responseUrlx = xmlDoc.createAttribute("responseURL");
        responseUrlx.setValue(responseUrl);
        root.setAttributeNode(responseUrlx);

        Attr maxWaitPeriodx = xmlDoc.createAttribute("maxWaitPeriod");
        maxWaitPeriodx.setValue(maxWaitPeriod);
        root.setAttributeNode(maxWaitPeriodx);

        Attr signAlgorithm = xmlDoc.createAttribute("signAlgorithm");
        signAlgorithm.setValue("ECC");
        root.setAttributeNode(signAlgorithm);

        txn.docs.each{
            Element document = xmlDoc.createElement("document");
            docs.appendChild(document);

            Attr dId = xmlDoc.createAttribute("Id");
            dId.setValue(it.id.toString());
            document.setAttributeNode(dId);

            Attr docInfo = xmlDoc.createAttribute("docInfo");
            docInfo.setValue(it.docInfo);
            document.setAttributeNode(dId);

            Attr pages = xmlDoc.createAttribute("pages");
            pages.setValue(it.page.toString());
            document.setAttributeNode(pages);

            Attr mandateQr = xmlDoc.createAttribute("mandateQr");
            mandateQr.setValue(it.isQRCoordinates.toString());
            document.setAttributeNode(mandateQr);

            Attr qrCoordinates = xmlDoc.createAttribute("qrCoordinates");
            if(it.qrCoordinates == 1){
                qrCoordinates.setValue(it.qrCoordinates);
            }else{
                qrCoordinates.setValue("");
            }
            document.setAttributeNode(qrCoordinates);
            if(it.lockPdf == 1){
                Attr lockPdf = xmlDoc.createAttribute("lockPdf");
                if(it.lockPdf == 1){
                    lockPdf.setValue(it.lockPdf.toString())
                }else{
                    lockPdf.setValue("")
                }
                document.setAttributeNode(lockPdf);
            }

            document.setTextContent("Base64")
        }
        //Document element attributes


        // create the xml file
        //transform the DOM Object to an XML File
        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        Transformer transformer = transformerFactory.newTransformer();
        DOMSource domSource = new DOMSource(xmlDoc);
        StringWriter writer = new StringWriter();
        StreamResult streamResult = new StreamResult(writer);//new StreamResult(new File(xmlFilePath));
        transformer.transform(domSource, streamResult);
        String strResult = writer.toString();

        return strResult

    }

    def postXML(String httpStr, String xmlStr) {
        HttpHeaders headers = new HttpHeaders();
        //HttpEntity<String> request = new HttpEntity<String>(body, headers);
    }

    Boolean toNumeralString(Boolean input) {
        if (input == null) {
            return "null";
        } else {
            return input? 1 : 0;
        }
    }
}