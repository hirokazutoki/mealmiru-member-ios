//
//  ContentView.swift
//  mealmiru-member-ios
//
//  Created by Hirokazu Toki on 2026/02/05.
//

import SwiftUI

struct ContentView: View {

    @available(iOS 26.0, *)
    var body: some View {
        NaticeTabView()
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
}

#Preview {
    ContentView()
}
