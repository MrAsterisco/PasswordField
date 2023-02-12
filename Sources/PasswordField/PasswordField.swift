#if !os(tvOS)
import SwiftUI

#if os(macOS)
public typealias TextContentType = NSTextContentType
#elseif os(watchOS)
public typealias TextContentType = WKTextContentType
#else
public typealias TextContentType = UITextContentType
#endif

@available(tvOS, unavailable)
public extension PasswordField {
  enum VisibilityControlPosition {
    case  inlineInside,
          inlineOutside,
          below,
          hidden
    
    static var `default`: Self {
      #if os(macOS) || targetEnvironment(macCatalyst)
      return .below
      #else
      return .inlineInside
      #endif
    }
  }
}

/// A control into which the user securely enters private text with an option
/// to reveal the text.
///
/// # Overview
/// You create a password field with a label and a binding to a value. Optionally,
/// you can also pass a binding to a boolean value to manipulate the visibility of
/// the input.
///
/// # Style
/// By default, the text field is style appropriately for the target platform. The same
/// goes for the additional control to toggle the visibility of the input:
/// - On iOS and watchOS, a button with an eye icon is displayed inside the text field.
/// - On macOS (and when targeting Mac Catalyst), a checkbox is displayed below the text field.
///
/// You can customize the visibility control by passing a `visibilityControl` view builder.
///
/// # Bindings
/// By default, the only binding that you must pass is `text`. You can also apply
/// the modifier `inputVisible` to pass your own binding and control the visibility
/// of the input from outside (for example, if you have multiple password fields).
@available(tvOS, unavailable)
public struct PasswordField: View {
  public typealias VisibilityControlProvider = (Binding<Bool>) -> any View
  
  @Binding var text: String
  @Binding var inputVisible: Bool
  @State private var isInputVisible = false
  
  var title: LocalizedStringKey
  var visibilityControlPosition: VisibilityControlPosition = .default
  var textContentType: TextContentType = .password
  
  @ViewBuilder var visibilityControlProvider: VisibilityControlProvider
  @FocusState private var focusedField: Field?
  
  public init(
    _ title: LocalizedStringKey = "Password",
    text: Binding<String>
  ) {
    self.init(
      title,
      text: text,
      visibilityControl: {
        #if os(macOS) || targetEnvironment(macCatalyst)
        VisibilityToggle(
          isInputVisible: $0
        )
        #else
        VisibilityButton(
          isInputVisible: $0
        )
        #endif
      }
    )
  }
  
  public init(
    _ title: LocalizedStringKey = "Password",
    text: Binding<String>,
    @ViewBuilder visibilityControl: @escaping VisibilityControlProvider
  ) {
    self.title = title
    _text = text
    _inputVisible = .constant(false)
    self.visibilityControlProvider = visibilityControl
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
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
      
      #if !os(macOS)
      if visibilityControlPosition == .below {
        visibilityControl
      }
      #endif
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
  var textFields: some View {
    ZStack {
      textField
      secureField
    }
  }
  
  @ViewBuilder
  var textField: some View {
    TextField(title, text: $text)
      .focused($focusedField, equals: .visible)
      .opacity(isInputVisible ? 1 : 0)
      .autocorrectionDisabled()
      .textContentType(textContentType)
      #if !os(macOS)
      .textInputAutocapitalization(.never)
      #endif
  }
  
  @ViewBuilder
  var secureField: some View {
    SecureField(title, text: $text)
      .focused($focusedField, equals: .secure)
      .opacity(isInputVisible ? 0 : 1)
      .textContentType(textContentType)
  }
  
  @ViewBuilder
  var content: some View {
    #if os(macOS) || os(tvOS)
    Form {
      textFields
      if visibilityControlPosition == .below {
        visibilityControl
      }
    }
    #else
    textFields
    #endif
  }
  
  @ViewBuilder
  var visibilityControl: some View {
    AnyView(
      visibilityControlProvider($isInputVisible)
    )
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
#endif
