//
//  InfoView.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 16.10.2023.
//

import SwiftUI

struct AppInformationView: View {
  @State private var isTermsPresented = false
  @State private var isPolicyPresented = false
  
  private let appEmail = URL(string: "mailto:info.cryptopilot@gmail.com")!
  private let termsOfService = URL(string: "mailto:info.cryptopilot@gmail.com")!
  private let privacyPolicy = URL(string: "mailto:info.cryptopilot@gmail.com")!
  
  private let coingeckoURL = URL(string: "https://www.coingecko.com")!
  
  private let linkedInURL = URL(string: "https://www.linkedin.com/in/oleksiilibin/")!
  private let gitHubURL = URL(string: "https://github.com/AlekseyLibin?tab=repositories")!
  private let devEmail = URL(string: "mailto:libin.aleksey@gmail.com")!
  
    var body: some View {
      NavigationView {
        ZStack {
          Color.theme.background.ignoresSafeArea()
          List {
            appSection
            coingeckoSection
            developerSection
          }
          .listStyle(GroupedListStyle())
          .navigationTitle("Info")
          .tint(.blue)
          .toolbar {
            ToolbarItem(placement: .topBarLeading) {
              XMarkButton()
            }
          }
        }
      }
      .sheet(isPresented: $isPolicyPresented, onDismiss: {
        isPolicyPresented = false
      }, content: {
        PDFViewer(screenIsActive: $isPolicyPresented, pdfURL: Bundle.main.url(forResource: "Policy", withExtension: "pdf")!)
      })
      .sheet(isPresented: $isTermsPresented, onDismiss: {
          isTermsPresented = false
      }, content: {
        PDFViewer(screenIsActive: $isTermsPresented, pdfURL: Bundle.main.url(forResource: "Terms", withExtension: "pdf")!)
      })
    }
}

private extension AppInformationView {
  var appSection: some View {
    Section {
      VStack(alignment: .leading) {
        HStack {
          Image("logo")
            .resizable()
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 20))
          Text("Crypto Pilot")
            .font(.system(size: 40, weight: .bold, design: .default))
            .frame(maxWidth: .infinity, alignment: .center)
            .foregroundStyle(Color.gray.opacity(0.5))
        }
        Text("Crypto Pilot - an application for tracking the cryptocurrency market. Configure your portfolio, explore your favorite coins in detail, enjoy comprehensive charts and statistics for each individual coin, and relish the overall user experience!")
          .font(.callout)
          .fontWeight(.medium)
          .foregroundStyle(Color.theme.accent.opacity(0.8))
      }
      .padding(.vertical)
      Button("Terms of Use") {
        isTermsPresented = true
      }

      Button("Privacy Policy") {
        isPolicyPresented = true
      }
      Link("Support E-mail", destination: appEmail)
    } header: {
      Text("App")
    }
    .listRowBackground(Color.theme.background.opacity(0.5))
  }
  
  var coingeckoSection: some View {
    Section {
      VStack(alignment: .leading) {
        Image("coingecko")
          .resizable()
          .scaledToFit()
          .frame(height: 100)
          .clipShape(RoundedRectangle(cornerRadius: 20))
        Text("The application uses the open API provided by CoinGecko, offering detailed information about cryptocurrencies. Since the service is open, updates on precise cryptocurrency prices may experience delays.")
          .font(.callout)
          .fontWeight(.medium)
          .foregroundStyle(Color.theme.accent.opacity(0.8))
      }
      .padding(.vertical)
      Link("Visit CoinGecko 🦖", destination: linkedInURL)
    } header: {
      Text("api")
    }
    .listRowBackground(Color.theme.background.opacity(0.5))
  }
  
  var developerSection: some View {
    Section {
      VStack(alignment: .leading, spacing: 20) {
        HStack {
          Text("👨‍💻")
            .font(.system(size: 100, weight: .bold, design: .default))
          Text("Aleksey \n Libin")
            .font(.system(size: 40, weight: .bold, design: .default))
            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .center)
            .foregroundStyle(Color.gray.opacity(0.5))
        }
        Text(developerDescriptionText)
          .font(.callout)
          .fontWeight(.medium)
          .foregroundStyle(Color.theme.accent.opacity(0.8))
        
      }
      .padding(.vertical)
      Link("Let's connect with LinkedIn 🔗", destination: linkedInURL)
      Link("Check out my GitHub profile 💻", destination: gitHubURL)
      Link("E-Mail to contact ✉️", destination: devEmail)
    } header: {
      Text("Developer")
    }
    .listRowBackground(Color.theme.background.opacity(0.5))
  }
  
  var developerDescriptionText: String {
    return """
The application uses MVVM architecture pattern and only reactive approach, implemented using the native Combine framework. 

The application also adopts a multithreaded approach for fetching and processing data in the background thread.

Built on the Observer pattern, the app extensively utilizes publishers and subscribers. Significant effort has been invested in enhancing the app's performance, incorporating features such as data caching and storage in CoreData to prevent redundant network requests. Data reuse is also employed to optimize the construction of the user interface.

Thank you for trying out my application. I hope you had a positive experience using my project
"""
  }
}

#Preview {
    AppInformationView()
}
