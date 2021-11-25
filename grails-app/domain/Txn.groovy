

class Txn {

    String txnId
    Integer txnType = 1
    Boolean notifyUser
    User signer
    Date dateCreated
    Date lastUpdated
    static hasMany = [docs: Document]

    static constraints = {
        txnId()
        docs()
        notifyUser()
        signer()
    }
}
