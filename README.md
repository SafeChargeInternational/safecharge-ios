# Usage

First you will need to initialize the Payment context in the AppDelegate with the information provided from Safecharge.
	
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
       ServiceContext.init(enviorment: ServiceEnviorment.integration,
                            merchantId: “<MERCHANT ID>“,
                            merchantSiteId: “<MERCHANT SITE ID>“,
                            clientRequestId: “<CLIENT REQUEST ID>“,
                            secretKey: “<SECRET KEY>“)
        
        return true
    }

    
After that you will need to create and push PaymentViewController instance in your controller hierarchy.
In order to listen on the payment events - you will have to implement the PaymentViewProtocol. 
