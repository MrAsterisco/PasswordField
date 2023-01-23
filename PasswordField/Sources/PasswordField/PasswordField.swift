import SwiftUI

#if os(macOS)
public typealias TextContentType = NSTextContentType
#else
public typealias TextContentType = UITextContentType
#endif

public extension PasswordField {
  enum VisibilityControlPosition {
    case  inlineInside,
          inlineOutside,
          above,
          below,
          hidden
    
    static var `default`: Self {
      #if os(macOS)
      return .below
      #else
      return .inlineInside
      #endif
    }
  }
}

public struct PasswordField: View {
  public typealias VisibilityControlProvider = (Bool, @escaping () -> ()) -> any View
  
  @Binding var text: String
  @Binding var inputVisible: Bool
  @State private var isInputVisible = false
  
  var visibilityControlPosition: VisibilityControlPosition = .default
  var textContentType: TextContentType = .password
  
  @ViewBuilder var visibilityControl: VisibilityControlProvider
  @FocusState private var focusedField: Field?
  
  public init(
    text: Binding<String>
  ) {
    self.init(
      text: text,
      visibilityControl: {
        #if os(macOS)
        VisibilityToggle(
          action: $1,
          isInputVisible: $0
        )
        #else
        VisibilityButton(
          action: $1,
          isInputVisible: $0
        )
        #endif
      }
    )
  }
  
  public init(
    text: Binding<String>,
    @ViewBuilder visibilityControl: @escaping VisibilityControlProvider
  ) {
    _text = text
    _inputVisible = .constant(false)
    self.visibilityControl = visibilityControl
  }
  
  public var body: some View {
    let visibilityControl = AnyView(
      visibilityControl(isInputVisible) {
        isInputVisible.toggle()
      }
    )
    
    VStack(alignment: .leading) {
      if visibilityControlPosition == .above {
        visibilityControl
      }
      
      HStack {
        content
          .overlay(alignment: .trailing) {
            if visibilityControlPosition == .inlineInside {
              visibilityControl
            }
          }
          .onChange(of: isInputVisible) { newValue in
            inputVisible = newValue
            focusedField = isInputVisible ? .visible : .secure
          }
          .onChange(of: inputVisible) { newValue in
            isInputVisible = newValue
          }
        
        if visibilityControlPosition == .inlineOutside {
          visibilityControl
        }
      }
      
      if visibilityControlPosition == .below {
        visibilityControl
      }
    }
  }
}

// MARK: - Content
private extension PasswordField {
  private enum Field: Hashable {
    case  visible,
          secure
  }
  
  @ViewBuilder
  var content: some View {
    ZStack {
      TextField("Password", text: $text)
        .focused($focusedField, equals: .visible)
        .opacity(isInputVisible ? 1 : 0)
        .autocorrectionDisabled()
        .textContentType(textContentType)
      #if !os(macOS)
        .textInputAutocapitalization(.never)
      #endif
      
      SecureField("Password", text: $text)
        .focused($focusedField, equals: .secure)
        .opacity(isInputVisible ? 0 : 1)
        .textContentType(textContentType)
    }
  }
}

// MARK: - Modifiers
public extension PasswordField {
  func inputVisibile(_ binding: Binding<Bool>) -> Self {
    var newSelf = self
    newSelf._inputVisible = binding
    return newSelf
  }
  
  func visibilityControlPosition(_ position: VisibilityControlPosition) -> Self {
    var newSelf = self
    newSelf.visibilityControlPosition = position
    return newSelf
  }
  
  func textContentType(_ textContentType: TextContentType) -> Self {
    var newSelf = self
    newSelf.textContentType = textContentType
    return newSelf
  }
}

// MARK: - Preview
struct PasswordField_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      PasswordField(
        text: .constant("Test")
      )
      .padding()
      .cornerRadius(8)
      .overlay {
        RoundedRectangle(cornerRadius: 8)
          .stroke(.gray)
      }
      
      PasswordField(
        text: .constant("Revealed")
      )
      .padding()
      .cornerRadius(8)
      .overlay {
        RoundedRectangle(cornerRadius: 8)
          .stroke(.gray)
      }
    }
    .padding()
  }
}
