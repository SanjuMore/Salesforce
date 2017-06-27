public with sharing class SocietyManagementController {
 
        public Account society {get; set;}
        Public Integer size{get;set;} 
        public Integer noOfRecords{get;set;}
        public id soctyID {get;set;}
    	public Integer memberOptionsSize{get; set;}
   		public Boolean noMembers{get; set;}
 
        
        public String societyName {get; set;}
        public String regCode{get; set;}
        public String address{get; set;}
        public integer year{get; set;}
        public Boolean showStatus {get; set;}
        public Boolean showMembers{get; set;}
        public Boolean disableAddSecretary{get; set;}
        public Boolean disableAddMembers{get; set;}
    	public Boolean disableSaveSociety{get; set;}
        
        public List<Account> societies = new List<Account>();       
        public List<String> SelectedMembers = new List<String>();
        public List<SelectOption> memberOptions = new List<SelectOption>();
    	public List<SelectOption> yearOptions = new List<SelectOption>();
     	public List<SelectOption> existingList = new List<SelectOption>();
    
        public List<Contact> contactList = new List<Contact>();
        public List<contact> addedMembers = new List<Contact>();
    
    	
   		public Id chosenSociety {get;set;}
    
        //variables for pagination
        public Integer CountTotalRecords{get;set;}       
    public Integer QOffset {get; set;}
    	public Integer QLimit {get; set;}
       // public List<Account> lstAccount;

    
            //constructor
        public SocietyManagementController(){
           // size = 5; //page size for pagination
            CountTotalRecords= [select count() from Account];
            QLimit = 5;
            QOffset = 0;
            disableAddMembers = true;
            disableAddSecretary = true;
            disableSaveSociety = false;
            year=0;     
			system.debug('id after reloadd ' + ApexPages.currentPage().getParameters().get('scId'));
            if(ApexPages.currentPage().getParameters().get('scId')!=null){ 
                society = [select id, name,formation_year__c, registration_code__c, billingStreet, sec__c from Account 
                               where id = :ApexPages.currentPage().getParameters().get('scId')];
                    system.debug('society after reloadd ' + society);
                chosenSociety = society.id;        
                societyName = society.Name;
                regCode = society.Registration_Code__c;
                //keep a check for formation year == null
                if(society.Formation_Year__c != null){
                   year = society.Formation_Year__c.intValue();
                }
                
               
                address = society.BillingStreet;
                    
                addedMembers = [select id, name from Contact where 
                                    AccountId = :ApexPages.currentPage().getParameters().get('scId')];
                showMembers = true;     
                disableAddMembers = false;
                disableAddSecretary = false;
                disableSaveSociety = true;
         	}//end of if 
   
     }//end of constructor
    
    public List<SelectOption> getExistingList(){
        List<Account> existing = [select id, name from account];
        for(Account a : existing){
            existingList.add(new SelectOption(a.id,a.name));
        }
        return existingList;
    }
    	

    
    	//get the selected checkboxes member values from PopUpPage
    	public List<String> getSelectedMembers(){
        	return SelectedMembers;
    	}   
    
    	//setter for selectedMembers
    	public void setSelectedMembers(List<String> SelectedMembers){
        	this.selectedMembers = SelectedMembers;
    	}
    	
    	//getter for contactList - list to members to be added
    	public List<Contact> getContactList(){
       		return contactList;
    	}
    
        //Set options for checkboxes
        public List<SelectOption> getmemberOptions(){
        	List<Contact> possibleMembers = [select name from contact];
            for(Contact c : possibleMembers){
				memberOptions.add(new SelectOption(c.id,c.name));
            }
            return memberOptions;
        }
    	//set options for year
         public List<SelectOption> getYearOptions(){
               integer yr = 2000;
            
                for( yr = 2000; yr <= 2017; yr++ ){
                    yearOptions.add(new SelectOption(String.valueOf(yr),String.valueOf(yr)));
                }
                return yearOptions;
            }


 		//Add members to the society
    	public PageReference AddMembers(){
       		
        	contactList = [select id, Account.id, Account.name from Contact where id in :selectedMembers];
          
            if(contactList == null){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'There were no available members'));
             
                return null;
            }
         
        	for(Contact c : contactList){
            	c.AccountId = ApexPages.currentPage().getParameters().get('scId');  
        	}
        	
        	Account soc = [select id, name, number_of_members__c from account 
                           where id=:ApexPages.currentPage().getParameters().get('scId')];	
        	soc.Number_of_members__c = soc.Number_of_members__c + contactList.size();    
       		
            update contactList;
            //update soc;
        return null;
    	}

    
        //redirect to page to select members
        Public PageReference RedirectToPopUpPage(){ 
            
            showMembers = true;
            PageReference pf = Page.ContactsPopUpPage;
            pf.getParameters().put('scId',ApexPages.currentPage().getParameters().get('scId'));
            pf.setRedirect(true);
            return pf;
        }
    
    
    
        public List<Contact> getAddedMembers(){
            return addedMembers;
        }
    
      /*  //get all societies
        public List<Account> getsocieties(){           
            societies = (List<Account>)setcon.getRecords();            
            return societies;
        }*/
  //new pagination begins  
    //get all societies
        public List<Account> getsocieties(){           
            societies = [select id, name, sec__c, number_of_members__c, billingStreet,billingcity,billingstate,billingpostalcode,
                         billingcountry,billinglatitude from account limit :Qlimit offset :Qoffset];         
            return societies;
        }
    
     public Boolean getDisablePrevious(){
        if(QOffset>0){
            return false;
        }
        else return true;
    }

    public Boolean getDisableNext() {
        if (QOffset + QLimit < countTotalRecords){
            return false;
        }
        else return true;
    }

    public PageReference First() {
        QOffset = 0;
        return null;
    }
    
     public PageReference Last() {
        QOffset = CountTotalRecords-QLimit;
        return null;
    }
    
    public PageReference Next() {
        QOffset += QLimit;
        return null;
    }

    public PageReference Previous() {
        QOffset -= QLimit;
        return null;
    }

    
   //new pagination ends  
    
        //add new society in database
        public PageReference SaveSociety(){
            integer flag = 0;
            disableAddMembers = false;
            disableAddSecretary = false;
            disableSaveSociety = true;
            
            society = new Account(name = societyName, registration_code__c = regCode, 
                                  billingstreet = address, formation_year__c = year,
                                  number_of_members__c=0);
            try{
                insert society;
            }catch(DMLException de){
                society.addError('There was a problem ' + de.getMessage());
                flag=1;
            }
            
            if(flag==0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Society Saved!'));
            }
            soctyID = society.Id;
            showStatus = true;
            
            PageReference pg = Page.AddNewSociety;
            pg.getParameters().put('scId',society.Id);
            pg.setRedirect(true);
            //system.debug('pg = ' + pg.getUrl());
            return pg;
        }
        
       
        //update secretary of the society
        public PageReference AddSecretary(){
            
            system.debug('Before' + society.Sec__c);
            society.Sec__c = society.Sec__c;
            system.debug('After' + society.Sec__c);
            update society;
            
            return null;
        }
    
    public PageReference reloadd(){
        PageReference same = Page.AddNewSociety;
        same.getParameters().put('scId',chosenSociety);
        same.setRedirect(true);
        system.debug('pg = ' + same.getUrl());
        return same;
    }
 }