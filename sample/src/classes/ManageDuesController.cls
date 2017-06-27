public with sharing class ManageDuesController {

    public List<Account> societyList = new List<Account>();
    public List<Contact> defaultersList = new List<contact>();
    public  List<Dues__c> DuesList = new List<Dues__c>();
    public List<SelectOption> societyOptions = new List<SelectOption>();
    public List<SelectOption> months = new List<SelectOption>();   
   
    public double duesRemaining {get; set;}
    public String selectedSociety {get;set;}
    public String selectedMonth{get; set;}
    public integer year{get; set;}
    
    public Boolean showDefaultersList {get;set;}
    public Boolean showAddDuesSection {get; set;}
      
    public List<WrapperContact> Members = new List<WrapperContact>();
    List<SelectOption> YearOptions = new  List<SelectOption>();
    Map<id, Dues__c> existingDuesMap = new Map<id, Dues__c>();
    
        
        
    //constructor
    public ManageDuesController(){
        showAddDuesSection = false;
        showDefaultersList = false;
        Profile pro = [select name from profile where id = :UserInfo.getProfileId()];
        if(pro.name == 'Secretary'){
            societyList = [select id, name from Account where ownerId = :UserInfo.getUserId() ];
        }
        else{
            societyList = [select id, name from Account];
        }
      
         
    }
    
     //set options for year
         public List<SelectOption> getYearOptions(){
               integer yr = 2000;
            
                for( yr = 2000; yr <= 2017; yr++ ){
                    yearOptions.add(new SelectOption(String.valueOf(yr),String.valueOf(yr)));
                }
                return yearOptions;
            }
    
    //getter for societyList
    public List<Account> getSocietyList(){      
        return societyList;
    }
    
    //getter for societyOptions (set Options for society dropdown list)
    public List<SelectOption> getSocietyOptions(){
        
        for(Account society : societyList){
            societyOptions.add(new SelectOption(society.id,society.name));
        }
        return societyOptions;
    }
    
    //getter for members (defaulters checkboxes)
    public List<WrapperContact> getMembers(){
    	Members = new List<WrapperContact>();
       	getDefaulters();
        for(Contact c : defaultersList){
            WrapperContact wc = new WrapperContact(c);
            if(existingDuesMap.containsKey(c.id)){
                wc.duesRemaining = existingDuesMap.get(c.id).dues_remaining__c;
            }
            else{
                wc.duesRemaining = duesRemaining;
            }
            members.add(wc);
        }
        return members;
    }

    
    
    //getter for months (set Options for dropdown list)
    public List<SelectOption> getMonths(){
        months.add(new SelectOption('January','January'));
         months.add(new SelectOption('February','February'));
         months.add(new SelectOption('March','March'));
         months.add(new SelectOption('April','April'));
         months.add(new SelectOption('May','May'));
         months.add(new SelectOption('June','June'));
         months.add(new SelectOption('July','July'));
         months.add(new SelectOption('August','August'));
         months.add(new SelectOption('September','September'));
         months.add(new SelectOption('October','October'));
         months.add(new SelectOption('November','November'));
         months.add(new SelectOption('December','December'));
     	return months;   
    }
    
    //fetch all defaulters from database
    public PageReference getDefaulters(){
        
         //get the monthly charges for the selected society
        List<Account> socs = [select id, Monthly_Dues__c from Account where id = :selectedSociety];
        double monthlyFees = socs.get(0).Monthly_Dues__c;
        duesRemaining = monthlyFees;
        
       /* defaultersList = [select name , email , account.monthly_dues__c from contact 
                          where accountid = :selectedSociety and id not in 
                          (select member_name__c from dues__c where  month__c =:selectedMonth and year__c = :year) ];*/
        
         defaultersList = [select name , email , account.monthly_dues__c from contact 
                          where accountid = :selectedSociety and id not in 
                          (select member_name__c from dues__c where  month__c =:selectedMonth and year__c = :year and Amount_Paid__c = :monthlyFees)];
        
        List<Dues__c> existingDues  = [select id,name, member_name__c,month__c,year__c,amount_paid__c,dues_remaining__c from dues__c 
                                         where  month__c = :selectedMonth and year__c = :year and member_name__r.accountId = :selectedSociety];
        
        	
        	for(Dues__c d : existingDues )
        	{
            	existingDuesMap.put(d.Member_name__c, d);
        	}
       
        system.debug(defaultersList.size());
        
        	
        
        return null;
    }
    
    //getter for defaultersList
    public List<Contact> getDefaultersList(){
        return defaultersList;
    }
    
    //list of added dues
    public List<Dues__c> getDuesList(){
        return DuesList;
    }
  
    //Add Dues for members of selected society for selected month and year
    public PageReference AddDues(){
        system.debug('Adding Dues');
        DuesList = new List<Dues__c>();
        List<Dues__c> existingEntries = [select id,name, member_name__c,month__c,year__c,amount_paid__c from dues__c 
                                         where  month__c = :selectedMonth and year__c = :year and member_name__r.accountId = :selectedSociety];
        Map<id, Dues__c> existingEntriesMap = new Map<id, Dues__c>();
        for(Dues__c d : existingEntries )
        {
            existingEntriesMap.put(d.Member_name__c, d);
        }
        Dues__c ds ;
        
        for(WrapperContact wc : members){
            ds = new Dues__c();
            ds.Member_Name__c = wc.c.id;          
            ds.Month__c = selectedMonth;
            ds.Year__c = year;          

            if(existingEntriesMap.containsKey(ds.Member_Name__c)){
                ds.Amount_Paid__c = existingEntriesMap.get(ds.Member_Name__c).amount_paid__c + wc.amount;
                ds.Id = existingEntriesMap.get(ds.Member_Name__c).id;
                system.debug('check in map' + ds.Amount_Paid__c);
            }
            else{
                 ds.Amount_Paid__c = wc.amount;
            }
            
            if(ds.Amount_Paid__c > 0 && ds.Amount_Paid__c <= wc.c.Account.monthly_dues__c){
                DuesList.add(ds);
            }
  
        }
        if(DuesList.size() == 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Enter the correct amount'));
                 return null;
        }	
        
        
        system.debug('list' + duesList);
        system.debug('map' + existingEntriesMap);
     	upsert duesList;
        return null;
    }
    
    //show Defaulters List on page
    public PageReference enableDefaultersSection(){   
        getDefaulters();
        showDefaultersList = true;
        showAddDuesSection = false;      
        UpdateEmailTemplate();
        return null;
    }
    
    //show add Dues section on page
    public PageReference enableDuesSection(){
       	getDefaulters();
        showAddDuesSection = true;
        showDefaultersList = false;
        return null;
    }
   
    public void setFieldToSendMail(){
        
        List<Contact> sendTo = new List<contact>();   
        for(WrapperContact wc : members){
            if(wc.selected == true)
            	wc.c.Send_Email__c = true;
            sendTo.add(wc.c);
        }
       
       
         try{
               update sendTo;
            
        }catch(DMLException de){
            ApexPages.addMessage(new ApexPages.Message(ApexPAges.Severity.WARNING,de.getMessage()));
        }
        
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Email successfully sent!'));
      
    }
    
    public void UpdateEmailTemplate(){
         EmailTemplate et=[Select id,body from EmailTemplate where Name=:'Reminder for payment']; 
       	EmailTemplate dummy = [Select id,body from EmailTemplate where Name=:'Dummy']; 
        String message =  et.body.replace('selectedMonth', selectedMonth);
        message = message.replace('selectedYear', String.valueOf(year));
       
        
 		dummy.Body = message;   
         try{
              update dummy;
             system.debug('updated');
            
        }catch(DMLException de){
            ApexPages.addMessage(new ApexPages.Message(ApexPAges.Severity.WARNING,de.getMessage()));
        }
    }
 
}