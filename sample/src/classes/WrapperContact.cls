public with sharing class WrapperContact {
    public Contact c {get; set;}
    public Integer amount{get; set;}
    public Boolean selected {get; set;}
    public double duesRemaining{get; set;}
    public List<Dues__c> existingDues = new List<Dues__c>();
    
    public WrapperContact( Contact con){
        c = con;
        amount = 0;
        selected = false;
    }
    
    
    

}