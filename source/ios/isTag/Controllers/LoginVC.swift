//
//  ViewController.swift
//  isTag
//
//  Created by Domo on 19/07/2019.
//  Copyright © 2019 Domo. All rights reserved.
//

import UIKit
import MSAL

class LoginVC: UIViewController {

    let kClientID = "b8634b10-e169-4368-8d3c-f52e7f721657"
    let kAuthority = "https://login.microsoftonline.com/1487c148-d41b-46a9-988b-4fa3f16d1741"

    
    // Additional variables for Auth and Graph API
    let kGraphURI = "https://graph.microsoft.com/v1.0/me/"
    let kScopes: [String] = ["https://graph.microsoft.com/user.read"]
    let kTenant: [String] = ["1487c148-d41b-46a9-988b-4fa3f16d1741"]
    
    var accessToken = String()
    var applicationContext : MSALPublicClientApplication?
    
    var loggingText: UITextView!
    var signOutButton: UIButton!
    var callGraphButton: UIButton!
    
    var isTest = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        do {
            try self.initMSAL()
        } catch let error {
            print("error")
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.isTest = appDelegate.isTest
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        // vado al TVC con i settings
        callGraphAPI()
        performSegue(withIdentifier: "showCamera", sender: nil)
        
    }
    
    
    @IBAction func callAlive(_ sender: Any) {
        
        var source: RequestProtocol
        if (self.isTest == 0) {
            source = Requests()
        } else {
            source = TestMockup()
        }
        
        let objNetworkManager = NetworkManager(shared: source)
        objNetworkManager.shared.isAlive(token: self.accessToken)
        
    }

}

extension LoginVC {
    
    func initMSAL() throws {
        
        guard let authorityURL = URL(string: kAuthority) else {
            self.loggingText.text = "Unable to create authority URL"
            return
        }
        
        let authority = try MSALAADAuthority(url: authorityURL)
        
        let msalConfiguration = MSALPublicClientApplicationConfig(clientId: kClientID, redirectUri: nil, authority: authority)
        self.applicationContext = try MSALPublicClientApplication(configuration: msalConfiguration)
    }
}

extension LoginVC {
    
    /**
     This will invoke the authorization flow.
     */
    
    @objc func callGraphAPI() {
        
        guard let currentAccount = self.currentAccount() else {
            // We check to see if we have a current logged in account.
            // If we don't, then we need to sign someone in.
            acquireTokenInteractively()
            return
        }
        
        acquireTokenSilently(currentAccount)
    }
    
    func acquireTokenInteractively() {
        
        guard let applicationContext = self.applicationContext else { return }
        
        let parameters = MSALInteractiveTokenParameters(scopes: kScopes)
        
        applicationContext.acquireToken(with: parameters) { (result, error) in
            
            if let error = error {
                
                return
            }
            
            guard let result = result else {
                
                return
            }
            
            self.accessToken = result.accessToken
            self.getContentWithToken()
        }
    }
    
    func acquireTokenSilently(_ account : MSALAccount!) {
        
        guard let applicationContext = self.applicationContext else { return }
        
        /**
         
         Acquire a token for an existing account silently
         
         - forScopes:           Permissions you want included in the access token received
         in the result in the completionBlock. Not all scopes are
         guaranteed to be included in the access token returned.
         - account:             An account object that we retrieved from the application object before that the
         authentication flow will be locked down to.
         - completionBlock:     The completion block that will be called when the authentication
         flow completes, or encounters an error.
         */
        
        let parameters = MSALSilentTokenParameters(scopes: kScopes, account: account)
        
        applicationContext.acquireTokenSilent(with: parameters) { (result, error) in
            
            if let error = error {
                
                let nsError = error as NSError
                
                // interactionRequired means we need to ask the user to sign-in. This usually happens
                // when the user's Refresh Token is expired or if the user has changed their password
                // among other possible reasons.
                
                if (nsError.domain == MSALErrorDomain) {
                    
                    if (nsError.code == MSALError.interactionRequired.rawValue) {
                        
                        DispatchQueue.main.async {
                            self.acquireTokenInteractively()
                        }
                        return
                    }
                }
                
                
                return
            }
            
            guard let result = result else {
                
                return
            }
            
            self.accessToken = result.accessToken
            self.getContentWithToken()
            
        }
    }
    
    /**
     This will invoke the call to the Microsoft Graph API. It uses the
     built in URLSession to create a connection.
     */
    
    func getContentWithToken() {
        
        // Specify the Graph API endpoint
        let url = URL(string: kGraphURI)
        var request = URLRequest(url: url!)
        
        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                return
            }
            
            guard let result = try? JSONSerialization.jsonObject(with: data!, options: []) else {
                
                return
            }
            print(result)
            }.resume()
    }
    
}


// MARK: Get account and removing cache

extension LoginVC {
    func currentAccount() -> MSALAccount? {
        
        guard let applicationContext = self.applicationContext else { return nil }
        
        // We retrieve our current account by getting the first account from cache
        // In multi-account applications, account should be retrieved by home account identifier or username instead
        
        do {
            
            let cachedAccounts = try applicationContext.allAccounts()
            
            if !cachedAccounts.isEmpty {
                return cachedAccounts.first
            }
            
        } catch let error as NSError {
            
            print("error")
        }
        
        return nil
    }
    
    /**
     This action will invoke the remove account APIs to clear the token cache
     to sign out a user from this application.
     */
    @objc func signOut(_ sender: UIButton) {
        
        guard let applicationContext = self.applicationContext else { return }
        
        guard let account = self.currentAccount() else { return }
        
        do {
            
            /**
             Removes all tokens from the cache for this application for the provided account
             
             - account:    The account to remove from the cache
             */
            
            try applicationContext.remove(account)
            self.loggingText.text = ""
            self.signOutButton.isEnabled = false
            self.accessToken = ""
            
        } catch let error as NSError {
            print("error sign out")
        }
    }
    
    
}

extension LoginVC {
    
    
    
}
