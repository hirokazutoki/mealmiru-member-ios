//
//  ContentView.swift
//  mealmiru-member-ios
//
//  Created by Hirokazu Toki on 2026/02/05.
//

import GoogleSignIn
import GoogleSignInSwift
import SwiftUI



struct LoginResponse: Decodable {
    let token: String
    let user: UserResponse
}

struct UserResponse: Decodable {
    let id: Int
    let email: String?
    let name: String
}

struct ContentView: View {
    
    @State private var user: GIDGoogleUser?

    @available(iOS 26.0, *)
    var body: some View {
        VStack {
          // Check if the user is signed in.
            if user != nil {
              NaticeTabView()
          } else {
              // If not signed in, show the "Sign in with Google" button.
              Spacer()

              Image("AppLogo") // Assets.xcassets の名前
                  .resizable()
                  .scaledToFit()
                  .frame(width: 180, height: 180)
                  .shadow(radius: 8)

              Text("mealmiru")
                  .font(.title2)
                  .fontWeight(.semibold)
                  .padding(.top, 12)
              
              GoogleSignInButton(
                  scheme: .light,
                    style: .wide,
                    state: .normal,
                    action: handleSignInButton
              )
              .padding()

              Spacer()
          }
        }
    }

    private var hasCheckedItem: Bool {
        toEatItems.contains { $0.isChecked }
    }


    @State private var toEatItems: [ToEatItem] = [
        ToEatItem(
            name: "Carrot",
            expDate: Calendar.current.date(
                from: DateComponents(year: 2026, month: 3, day: 3)
            )
        ),
        ToEatItem(
            name: "Egg",
            expDate: nil
        ),
        ToEatItem(
            name: "Tomato",
            expDate: Calendar.current.date(
                from: DateComponents(year: 2026, month: 2, day: 10) )
        ),
    ]
    @State private var showAddToEatSheet = false

    @ViewBuilder
    private func NaticeTabView() -> some View {
        TabView{
            Tab.init("Home", systemImage: "house.fill") {
                NavigationStack{
                    VStack {
                        Spacer()

                        Image("AppLogo") // Assets.xcassets の名前
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 180)
                            .shadow(radius: 8)

                        Text("mealmiru")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top, 12)

                        Spacer()
                    }
                    .navigationTitle("Home")
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                // プロフィール画面へ
                            } label: {
                                Image(systemName: "person.2.fill")
                                    .frame(width: 32, height: 32)
                            }
                            .navigationTitle("Group Setting")
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                // プロフィール画面へ
                            } label: {
                                Image(systemName: "gearshape.fill")
                                    .frame(width: 32, height: 32)
                            }
                            .navigationTitle("Group Setting")
                        }
                    }
                }
            }

            Tab.init("To Eat", systemImage: "refrigerator.fill") {
                NavigationStack{
                    List {
                        ForEach($toEatItems) { $item in
                            HStack(spacing: 12) {

                                Button {
                                    item.isChecked.toggle()
                                } label: {
                                    Image(systemName: item.isChecked
                                          ? "checkmark.circle.fill"
                                          : "circle")
                                        .font(.system(size: 22))
                                        .foregroundStyle(
                                            item.isChecked ? .blue : .secondary
                                        )
                                }
                                .buttonStyle(.plain)

                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)

                                    if let date = item.expDate {
                                        Text(date, style: .date)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }

                                Spacer()

                                Button {
                                    // Edit
                                } label: {
                                    Image(systemName: "info.circle")
                                        .foregroundStyle(.blue)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .navigationTitle("To Eat")
                    .listStyle(.plain)
                    .safeAreaInset(edge: .bottom, alignment: .trailing) {
                        if hasCheckedItem {
                            // Ate ボタン（仮）
                            Button {
                                // TODO: Ate 機能は後回し
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "fork.knife")
                                    Text("Done")
                                        .fontWeight(.semibold)
                                }
                                .foregroundStyle(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 14)
                                .frame(height: 60)
                                .background(Color.blue)
                                .clipShape(Capsule())
                                .shadow(radius: 4)
                            }
                            .padding(.trailing, 20)
                            .padding(.bottom, 24)

                        } else {
                            // ＋ボタン（従来）
                            Button {
                                showAddToEatSheet = true
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(.white)
                                    .frame(width: 60, height: 60)
                                    .background(Color.accentColor)
                                    .clipShape(Circle())
                                    .shadow(radius: 4)
                            }
                            .padding(.trailing, 20)
                            .padding(.bottom, 24)
                        }
                    }

                    .sheet(isPresented: $showAddToEatSheet) {
                        AddToEatView(items: $toEatItems)
                    }
                }
            }

            Tab.init("Want", systemImage: "fork.knife") {
                NavigationStack{
                    List {
                        
                    }
                    .navigationTitle("Want")
                }
            }
            
            Tab.init("Calendar", systemImage: "calendar") {
                NavigationStack{
                    List {
                        
                    }
                    .navigationTitle("Calendar")
                }
            }

            Tab.init("To Buy", systemImage: "basket.fill") {
                NavigationStack{
                    List {
                        
                    }
                    .navigationTitle("To Buy")
                }
            }
        }
    }

    func handleSignInButton() {
        // Find the current window scene.
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
          print("There is no active window scene")
          return
        }

        // Get the root view controller from the window scene.
        guard
          let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?
            .rootViewController
        else {
          print("There is no key window or root view controller")
          return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
                guard
                    let result = signInResult,
                    let idToken = result.user.idToken?.tokenString
                else {
                    print("Sign-in failed:", error?.localizedDescription ?? "")
                    return
                }
            
                self.user = result.user

                print("ID Token:", idToken)

                // 👇 Laravel API にログイン
                loginToMealMiruMember(idToken: idToken)
            }
    }
    
    func loginToMealMiruMember(idToken: String) {
        guard let url = URL(string: "http://localhost/api/v1/auth/google") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = [
            "id_token": idToken
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("API error:", error)
                return
            }

            guard let data = data else {
                print("No response data")
                return
            }

            do {
                let decoded = try JSONDecoder().decode(LoginResponse.self, from: data)
                print("Sanctum Token:", decoded.token)

                // 🔐 本来は Keychain に保存
                UserDefaults.standard.set(decoded.token, forKey: "api_token")

            } catch {
                print("Decode error:", error)
                print(String(data: data, encoding: .utf8) ?? "")
            }
        }.resume()
    }

    
}

#Preview {
    ContentView()
}
