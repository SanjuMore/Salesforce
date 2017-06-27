@isTest
public class TestManageDuesController {
    
    static testmethod void testViewDefaulterswithValidYear(){       
        Account society = new Account(name = 'testSociety');
        List<contact> members = new List<Contact>();
        insert society;
        
        for(integer i = 1 ; i<=5; i++){
            members.add(new Contact(lastname = 'Contact '+ i,accountId=society.Id));
        }
        
        insert members;
        
        test.startTest();
        
        PageReference pf = Page.ManageDues;
        test.setCurrentPage(pf);
        ManageDuesController md = new ManageDuesController();
        md.selectedSociety = society.Id;
        md.selectedMonth = 'March';
        md.year = 2017;
        md.enableDefaultersSection();
        
        test.stopTest();
        
       system.assert(md.defaultersList.size() == members.size());

    }
    
    static testmethod void testViewDefaulterswithInValidYear(){       
        Account society = new Account(name = 'testSociety');
        List<contact> members = new List<Contact>();
        insert society;
        
        for(integer i = 1 ; i<=5; i++){
            members.add(new Contact(lastname = 'Contact '+ i,accountId=society.Id));
        }
        
        insert members;
        
        test.startTest();
        
        PageReference pf = Page.ManageDues;
        test.setCurrentPage(pf);
        ManageDuesController md = new ManageDuesController();
        md.selectedSociety = society.Id;
        md.selectedMonth = 'March';
        md.year = 1980;
        md.enableDefaultersSection();
        
       		
        ApexPages.Message message = new ApexPages.message(ApexPages.Severity.INFO,'Please enter a year from 2000-2017' );

        test.stopTest();
        HelperClass h = new HelperClass();
       System.assert(h.isMessagePresent(message));

    }
    
    static testmethod void testViewDefaulterswithoutYear(){       
        Account society = new Account(name = 'testSociety');
        List<contact> members = new List<Contact>();
        insert society;
        
        for(integer i = 1 ; i<=5; i++){
            members.add(new Contact(lastname = 'Contact '+ i,accountId=society.Id));
        }
        
        insert members;
        
        test.startTest();
        
        PageReference pf = Page.ManageDues;
        test.setCurrentPage(pf);
        ManageDuesController md = new ManageDuesController();
        md.selectedSociety = society.Id;
        md.selectedMonth = 'March';
        md.year = 0.0;
        md.enableDefaultersSection();
   		
        ApexPages.Message message = new ApexPages.message(ApexPages.Severity.INFO,'Please enter a valid year!' );

        test.stopTest();
        HelperClass h = new HelperClass();
       System.assert(h.isMessagePresent(message));


    }
    
    static testmethod void testAddDueswithValidYear(){       
        Account society = new Account(name = 'testSociety');
        List<contact> members = new List<Contact>();
        insert society;
        
        for(integer i = 1 ; i<=5; i++){
            members.add(new Contact(lastname = 'Contact '+ i,accountId=society.Id));
        }
        
        insert members;
        
        test.startTest();
        
        PageReference pf = Page.ManageDues;
        test.setCurrentPage(pf);
        ManageDuesController md = new ManageDuesController();
        md.selectedSociety = society.Id;
        md.selectedMonth = 'March';
        md.year = 2017;
        md.enableDuesSection();
        
        test.stopTest();
        
       system.assert(md.defaultersList.size() == members.size());

    }
    
    static testmethod void testAddDueswithInValidYear(){       
        Account society = new Account(name = 'testSociety');
        List<contact> members = new List<Contact>();
        insert society;
        
        for(integer i = 1 ; i<=5; i++){
            members.add(new Contact(lastname = 'Contact '+ i,accountId=society.Id));
        }
        
        insert members;
        
        test.startTest();
        
        PageReference pf = Page.ManageDues;
        test.setCurrentPage(pf);
        ManageDuesController md = new ManageDuesController();
        md.selectedSociety = society.Id;
        md.selectedMonth = 'March';
        md.year = 1980;
        md.enableDuesSection();
        
       		
        ApexPages.Message message = new ApexPages.message(ApexPages.Severity.INFO,'Please enter a year from 2000-2017' );

        test.stopTest();
        HelperClass h = new HelperClass();
       System.assert(h.isMessagePresent(message));

    }
    
    static testmethod void testAddDueswithoutYear(){       
        Account society = new Account(name = 'testSociety');
        List<contact> members = new List<Contact>();
        insert society;
        
        for(integer i = 1 ; i<=5; i++){
            members.add(new Contact(lastname = 'Contact '+ i,accountId=society.Id));
        }
        
        insert members;
        
        test.startTest();
        
        PageReference pf = Page.ManageDues;
        test.setCurrentPage(pf);
        ManageDuesController md = new ManageDuesController();
        md.selectedSociety = society.Id;
        md.selectedMonth = 'March';
        md.year = 0.0;
        md.enableDuesSection();
   		
        ApexPages.Message message = new ApexPages.message(ApexPages.Severity.INFO,'Please enter a valid year!' );

        test.stopTest();
        HelperClass h = new HelperClass();
       System.assert(h.isMessagePresent(message));


    }
    
    static testMethod void addDuesForSelectedMembers(){
          integer amt = 1000;
        Account society = new Account(name = 'testSociety',monthly_dues__c = amt);
        List<contact> Societymembers = new List<Contact>();
        insert society;
        
        for(integer i = 1 ; i<=5; i++){
            Societymembers.add(new Contact(lastname = 'Contact '+ i,accountId=society.Id));
        }
        
        insert Societymembers;
      
        test.startTest();
        
        PageReference pf = Page.ManageDues;
        test.setCurrentPage(pf);
        ManageDuesController md = new ManageDuesController();
        md.selectedSociety = society.Id;
        md.selectedMonth = 'March';
        md.year = 2017;
        md.enableDuesSection();
        md.getMembers();
        md.Members.get(0).amount=amt;
        md.Members.get(2).amount=amt;
        md.Members.get(3).amount=amt;
        integer memSize = md.Members.size();
        md.AddDues();
        md.getDefaulters();
        integer Count = 3;
        
 
        system.assertEquals(memSize - count, md.defaultersList.size());
        
    }
    
    static testMethod void addDuesForSelectedMembersWithNoneSelected(){
          integer amt = 1000;
        Account society = new Account(name = 'testSociety',monthly_dues__c = amt);
        List<contact> Societymembers = new List<Contact>();
        insert society;
        
        for(integer i = 1 ; i<=5; i++){
            Societymembers.add(new Contact(lastname = 'Contact '+ i,accountId=society.Id));
        }
        
        insert Societymembers;
      
        test.startTest();
        
        PageReference pf = Page.ManageDues;
        test.setCurrentPage(pf);
        ManageDuesController md = new ManageDuesController();
        md.selectedSociety = society.Id;
        md.selectedMonth = 'March';
        md.year = 2017;
        md.enableDuesSection();
        md.getMembers();  
        integer memSize = md.Members.size();
        md.AddDues();
        md.getDefaulters();
        integer Count = 3;
        
        HelperClass h = new HelperClass();
        ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.INFO,'Enter the correct amount');
        
        system.assert(h.isMessagePresent(message));
        
    }

    static testMethod void testSendingReminderMails(){
          integer amt = 1000;
        Account society = new Account(name = 'testSociety',monthly_dues__c = amt);
        List<contact> Societymembers = new List<Contact>();
        insert society;
        
        for(integer i = 1 ; i<=5; i++){
            Societymembers.add(new Contact(lastname = 'Contact '+ i,accountId=society.Id,email = 'contact'+i+'test@mailinator.com'));
        }
        
        insert Societymembers;
      
        test.startTest();
        
        PageReference pf = Page.ManageDues;
        test.setCurrentPage(pf);
        ManageDuesController md = new ManageDuesController();
        md.selectedSociety = society.Id;
        md.selectedMonth = 'March';
        md.year = 2017;
        md.enableDefaultersSection();
        md.getMembers();  
        md.Members.get(0).selected = true;
        md.Members.get(2).selected = true;
        md.Members.get(3).selected = true;
        md.InitializeMails();
    }
    
    static testMethod void testSendingReminderMailsWithoutSelectedMembers(){
          integer amt = 1000;
        Account society = new Account(name = 'testSociety',monthly_dues__c = amt);
        List<contact> Societymembers = new List<Contact>();
        insert society;
        
        for(integer i = 1 ; i<=5; i++){
            Societymembers.add(new Contact(lastname = 'Contact '+ i,accountId=society.Id,email = 'contact'+i+'test@mailinator.com'));
        }
        
        insert Societymembers;
      
        test.startTest();
        
        PageReference pf = Page.ManageDues;
        test.setCurrentPage(pf);
        ManageDuesController md = new ManageDuesController();
        md.selectedSociety = society.Id;
        md.selectedMonth = 'March';
        md.year = 2017;
        md.enableDefaultersSection();
        md.getMembers();  
        md.InitializeMails();
         ApexPages.Message message = new ApexPages.message(ApexPages.Severity.WARNING,'Please Select Members first!');
        HelperClass h = new HelperClass();
        system.assert(h.isMessagePresent(message));
    }
}