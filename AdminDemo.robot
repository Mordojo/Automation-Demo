*** Settings ***
Library    SeleniumLibrary        
Library    OperatingSystem    
Library    String
Library    Dialogs
Library    REST
Library    JSONLibrary
Suite Setup    Set Locators From Json    AdminElements.json    
Test Setup    Open JMap Admin    ${URLAdmin}                       


*** Variables ***
#Robot --listener allure_robotframework;/set/your/path/here ./my_robot_test
#Robot AutomationDemo && robotmetrics
${URLAdmin}    http://formation1.jmaponline.net:8080
${USERNAME}    administrator
${PASSWORD}    ${EMPTY}
${AdminElement}    ${EMPTY}    

*** Test Cases ***
Login_with_valid_credentials
    Login With Creddentials    ${USERNAME}    ${PASSWORD}
    Verify That The Initial Page Is    Status
    Logout From JMap Admin
    
#Test
    #${json}    Load JSON From File    ${CURDIR}${/}Files${/}AdminElements.json
    #${json}    Get Value From Json    ${json}    $.Username 
    

*** Keywords ***

Set Locators From Json    [Arguments]    ${pJsonFile}   
    ${readJson}    Get File    ${CURDIR}${/}Files${/}${pJsonFile} 
    ${AdminElement}=    Evaluate    json.loads('''${readJson}''')    json
    Set Suite Variable    ${AdminElement}        
            
Open JMap Admin    [Arguments]    ${url}
    Open Browser    ${url}    Chrome
    Maximize Browser Window    
    
Login With Creddentials    [Arguments]    ${pUSERNAME}    ${pPASSWORD}
    Log    ${AdminElement["Username"]}    
    Wait Until Element Is Visible    ${AdminElement["Username"]}    7s
    Input Text    ${AdminElement["Username"]}    ${pUSERNAME}
    Input Text    ${AdminElement["Password"]}    ${pPASSWORD}
    Click Button    ${AdminElement["Login"]}    
        
Verify That The Initial Page Is    [Arguments]    ${text}
    Wait Until Element Is Visible    ${AdminElement["StatusPage"]}    7s
    Run Keyword And Continue On Failure    Element Should Contain    ${AdminElement["StatusPage"]}    ${text}                
       
Logout From JMap Admin
    Wait Until Element Is Visible    ${AdminElement["UserMenu"]}    7s
    Click Element    ${AdminElement["UserMenu"]}    
    Wait Until Element Is Visible    ${AdminElement["Logout"]}    7s   
    Click Element    ${AdminElement["Logout"]}
    Sleep    2s 
    Close Browser   
	
# Add Lot of Changes ... !!!