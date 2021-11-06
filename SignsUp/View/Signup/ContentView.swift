//
//  ContentView.swift
//  SignsUp
//
//  Created by Markim Shaw on 11/3/21.
//

import SwiftUI

struct ContentView: View {
  @AppStorage("signup") private var signup: Bool = false
  @State private var isValidated: Bool = false
  @StateObject private var vm: SignupFormViewModel = SignupFormViewModel()
  
  var body: some View {
    VStack {
      Spacer()
      
      HeaderView()
      
      buildTextField(ofType: .username,
                          forBinding: $vm.username)
        .animation(.default)
      buildTextField(ofType: .password,
                          forBinding: $vm.password)
      buildTextField(ofType: .repeatPassword,
                          forBinding: $vm.repeatPassword)
      
      SignupButton(action: {signup.toggle()})
      
      Spacer()
      Spacer()
    }
    .padding()
    .frame(maxWidth: .infinity)
    .onChange(of: vm.username) { newValue in
      print("The new username value is \(newValue)")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ContentView()
        .previewDevice("iPhone 12 mini")
      ContentView()
        .previewDevice("iPhone 13")
      ContentView()
        .previewDevice("iPod touch (7th generation)")
        .preferredColorScheme(.dark)
    }
    
  }
}

extension ContentView {
  private func buildTextField(ofType type: TextFieldType, forBinding binding: Binding<String>, isSecure: Bool = false) -> some View {
    HStack {
      Image(systemName: type.imageName)
      if isSecure {
        SecureField(type.rawValue, text: binding)
      } else {
        TextField(type.rawValue, text: binding)
      }
    }
    .padding()
    .modifier(
      InvalidTextFieldModifier(condition: !isInvalidTextField(forBinding: binding)))
  }
  
  private func isInvalidTextField(forBinding binding: Binding<String>) -> Bool {
    !binding.wrappedValue.isEmpty && binding.wrappedValue.count < 4
  }

  private func SignupButton(action: @escaping () -> Void) -> some View {
    Button(action: action) {
      Text("Sign up")
    }
    .disabled(vm.isValid ? false : true)
    .padding()
    .foregroundColor(.white)
    .background(
      RoundedRectangle(cornerRadius: 8.0)
        .fill(Color.blue)
    )
    .padding(.top)
  }
  
  private func HeaderView() -> some View {
    Text("Kookily")
      .font(.largeTitle)
      .bold()
  }
}
