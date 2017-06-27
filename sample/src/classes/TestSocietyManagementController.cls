@isTest
public class TestSocietyManagementController {

    static testmethod void testSaveSocietyWithoutName(){
       
        test.startTest();
      
        PageReference pf = Page.AddNewSociety;
        test.setCurrentPage(pf);
        SocietyManagementController sc = new SocietyManagementController();
        sc.societyName = '';
        sc.SaveSociety();
          
        
        ApexPages.Message message = new ApexPages.message(ApexPages.Severity.WARNING,'Please enter name for the society' );
   		HelperClass h = new HelperClass();
        system.assert(h.isMessagePresent(message));
        
        test.stopTest();
    }
    
    static testmethod void testSaveSocietyWithName(){
        
        test.startTest();
        
        PageReference pf = Page.AddNewSociety;
        test.setCurrentPage(pf);
        SocietyManagementController sc = new SocietyManagementController();
        sc.societyName = 'TestSociety';
        sc.SaveSociety();
        
        system.assertEquals('TestSociety', sc.society.name);
        
        test.stopTest();
    }
    
    static testmethod void testSaveSocietyWithInvalidYear(){
        
        test.startTest();
        
        PageReference pf = Page.AddNewSociety;
        test.setCurrentPage(pf);
        SocietyManagementController sc = new SocietyManagementController();
        sc.societyName = 'testSociety';
        sc.year = 1980;
        sc.SaveSociety();
        
        
		
        ApexPages.Message message = new ApexPages.message(ApexPages.Severity.WARNING,'Please enter correct year (2000-2017)' );
    
        HelperClass h = new HelperClass();
        system.assert(h.isMessagePresent(message));
        
        test.stopTest();
    }
    
    static testMethod void testSaveSocietyWithValidYear(){
        
        test.startTest();
        
        PageReference pf = Page.AddNewSociety;
        test.setCurrentPage(pf);
        SocietyManagementController sc = new SocietyManagementController();
        sc.societyName = 'testSociety';
        sc.year = 2016;
        sc.SaveSociety();
        
        System.assertEquals(sc.year, sc.society.formation_year__c);
        
        test.stopTest();
    }    

     static testMethod void testAddNewSocietyPagewithId(){

         Account soc = new Account(name = 'testSociety',formation_year__c=2017);
         insert soc;
        test.startTest();
		PageReference pf = Page.AddNewSociety;
        
        pf.getParameters().put('scId',soc.id);
        test.setCurrentPage(pf);
		SocietyManagementController sc = new SocietyManagementController();
          
        test.stopTest();
    }

    static testMethod void testAddMembers(){
        
        List<Contact> members = new List<Contact>();
        List<String> memberIds = new List<String>();
        for(integer i = 1; i <=5 ; i++){
            Contact c = new Contact(lastname = 'Contact '+i);
            members.add(c);
        }
        insert members;
        for(Contact c : members){
            memberIds.add(c.Id);
        }
        
        
        test.startTest();
		PageReference pf = Page.AddNewSociety;
        SocietyManagementController sc = new SocietyManagementController();
        sc.societyName = 'TestSociety';
        sc.SaveSociety(); 
        sc.setSelectedMembers(memberIds);
        sc.contactList = members;
        sc.getSelectedMembers();
        sc.getContactList();
        pf.getParameters().put('scId',sc.society.id);
        test.setCurrentPage(pf);
        PageReference redirectPage = sc.RedirectToPopUpPage(); 
        redirectPage.getParameters().put('scId',sc.society.id);
         sc.AddMembers();
        sc.getAddedMembers();
        system.assert(sc.contactList.size() == 5, 'Add Members error');
        test.stopTest();
    }
  
    
    static testMethod void testAddMembersWithSingle(){
        
        List<Contact> members = new List<Contact>();
        List<String> memberIds = new List<String>();
        for(integer i = 1; i <=1 ; i++){
            Contact c = new Contact(lastname = 'Contact '+i);
            members.add(c);
        }
        insert members;
        for(Contact c : members){
            memberIds.add(c.Id);
        }
        
        
        test.startTest();
		PageReference pf = Page.AddNewSociety;
        SocietyManagementController sc = new SocietyManagementController();
        sc.societyName = 'TestSociety';
        sc.SaveSociety(); 
        sc.setSelectedMembers(memberIds);
        sc.contactList = members;
        
        pf.getParameters().put('scId',sc.society.id);
        test.setCurrentPage(pf);
        PageReference redirectPage = sc.RedirectToPopUpPage(); 
        redirectPage.getParameters().put('scId',sc.society.id);
         sc.AddMembers();
        sc.getAddedMembers();
        system.assert(sc.contactList.size() == 1, 'Add Members error');
        test.stopTest();
    }
    
     static testMethod void testAddMembersWithNoMember(){
        
        List<Contact> members = new List<Contact>();
        List<String> memberIds = new List<String>();
    
        test.startTest();
		PageReference pf = Page.AddNewSociety;
        SocietyManagementController sc = new SocietyManagementController();
        sc.societyName = 'TestSociety';
        sc.SaveSociety(); 
        sc.setSelectedMembers(memberIds);
        sc.contactList = members;
        
        pf.getParameters().put('scId',sc.society.id);
        test.setCurrentPage(pf);
        PageReference redirectPage = sc.RedirectToPopUpPage(); 
        redirectPage.getParameters().put('scId',sc.society.id);
         sc.AddMembers();
        sc.getAddedMembers();
        system.assert(sc.contactList.size() == 0, 'Add Members error');
        test.stopTest();
    }
    
    
    static testmethod void testAddSecretary(){
        
        Contact con = new Contact(lastname = 'secretary');
        test.startTest();
        
        PageReference pf = Page.AddNewSociety;
        test.setCurrentPage(pf);
        SocietyManagementController sc = new SocietyManagementController();
        sc.societyName = 'TestSociety';
        sc.SaveSociety();
        sc.society.sec__c = con.Id;
        sc.AddSecretary();
        system.assertEquals(con.Name, sc.society.sec__c);
        
        test.stopTest();
    }
  
}