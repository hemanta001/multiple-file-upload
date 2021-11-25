<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'txn.label', default: 'Txn')}" />
        <asset:javascript src="fileupload.js"/>
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>
        <a href="#create-txn" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
        <div class="nav" role="navigation">
            <ul>
                <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                <li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
            </ul>
        </div>
        <div id="create-txn" class="content scaffold-create" role="main">
            <h1><g:message code="default.create.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message" role="status">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${this.txn}">
            <ul class="errors" role="alert">
                <g:eachError bean="${this.txn}" var="error">
                <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
                </g:eachError>
            </ul>
            </g:hasErrors>
            <g:form resource="${this.txn}" method="POST" enctype='multipart/form-data'>
                <fieldset class="form">
%{--                    <f:all bean="txn" except="docs"/>--}%
                    <div class='fieldcontain required'>
                        <label for='signCoordinates'>Sign Coordinates
                            <span class='required-indicator'>*</span>
                        </label><input type="text" name="docs[0].signCoordinates" value="" required="" id="signCoordinates" />
                    </div>
                    <div class='fieldcontain required'>
                        <label for='page'>Page
                            <span class='required-indicator'>*</span>
                        </label><input type="number" name="docs[0].page" value="" required="" id="page" />
                    </div>
                    <div class='fieldcontain'>
                        <label for='isQRCoordinates'>Has QR Coordinates</label>
                        <input type="hidden" name="docs[0]._isQRCoordinates" />
                        <input type="checkbox" name="docs[0].isQRCoordinates" id="isQRCoordinates"  />
                    </div>
                    <div class='fieldcontain required'>
                        <label for='qrCoordinates'>Qr Coordinates
                            <span class='required-indicator'>*</span>
                        </label><input type="text" name="docs[0].qrCoordinates" value="" required="" id="qrCoordinates" />
                    </div>
                    <div class='fieldcontain required'>
                        <label for='file'>Document to be signed
                            <span class='required-indicator'>*</span>
                        </label><input type="file" name="file" value="" required="" id="file" multiple/>
                    </div>
                    <div class='fieldcontain required'>
                        <label for='docInfo'>Doc Info
                            <span class='required-indicator'>*</span>
                        </label><input type="text" name="docs[0].docInfo" value="" required="" id="docInfo" />
                    </div>
                    <div class='fieldcontain'>
                        <label for='lockPdf'>Lock PDF for other signer?</label>
                        <input type="hidden" name="docs[0]._lockPdf" />
                        <input type="checkbox" name="docs[0].lockPdf" id="lockPdf"  />
                    </div>
                </fieldset>
                <fieldset class="buttons">
                    <g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" />
                </fieldset>
            </g:form>
        </div>
    </body>
</html>
