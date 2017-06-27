public class HelperClass {
     ApexPages.Message[] pageMessages = ApexPages.getMessages();
        Boolean messageFound = false;

    public Boolean isMessagePresent(ApexPages.Message message){
        messageFound = false;
        for(ApexPages.Message msg : pageMessages) {
            if(msg.getSummary() == message.getSummary()   
                && message.getSeverity() == message.getSeverity()) {
                messageFound = true;        
            }
        }
        return messageFound;
    }
    
}