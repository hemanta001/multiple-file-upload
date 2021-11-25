

class Document {
    String signCoordinates
    Integer page
    Boolean isQRCoordinates = 0
    String qrCoordinates
    Boolean lockPdf = 0
    String docInfo


    static belongsTo = [txn: Txn,file:File]

    static mapping = {

    }
    static constraints = {

    }
}
