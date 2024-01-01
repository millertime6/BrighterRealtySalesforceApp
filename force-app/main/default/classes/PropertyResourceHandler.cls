@RestResource(urlMapping='/Property__c/*')
global with sharing class PropertyResourceHandler {
    @HttpPost
    global static void getRecord() {
        // Set the Access-Control-Allow-Origin header to allow requests from any domain
        RestContext.response.addHeader('Access-Control-Allow-Origin', '*');
        RestContext.response.statusCode = 200;
        ApexPages.currentPage().getHeaders().put('Access-Control-Allow-Origin', '*');
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        system.debug(res);
    }
}