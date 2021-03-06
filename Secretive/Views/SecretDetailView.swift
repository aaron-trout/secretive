import SwiftUI
import SecretKit

struct SecretDetailView<SecretType: Secret>: View {

    @State var secret: SecretType
    let keyWriter = OpenSSHKeyWriter()

    var body: some View {
        Form {
            Section {
                GroupBox(label: Text("Fingerprint")) {
                    HStack {
                        Text(keyWriter.openSSHFingerprint(secret: secret))
                        Spacer()
                    }
                        .frame(minWidth: 150, maxWidth: .infinity)
                        .padding()
                }.onDrag {
                    return NSItemProvider(item: NSData(data: self.keyWriter.openSSHFingerprint(secret: self.secret).data(using: .utf8)!), typeIdentifier: kUTTypeUTF8PlainText as String)
                }
                Spacer().frame(height: 10)
                GroupBox(label: Text("Public Key")) {
                    VStack {
                        Text(keyWriter.openSSHString(secret: secret))
                            .multilineTextAlignment(.leading)
                            .frame(minWidth: 150, maxWidth: .infinity)
                        HStack {
                            Spacer()
                            Button(action: copy) {
                                Text("Copy")
                            }
                        }
                    }
                    .padding()
                }
                .onDrag {
                    return NSItemProvider(item: NSData(data: self.keyString.data(using: .utf8)!), typeIdentifier: kUTTypeUTF8PlainText as String)
                }
                Spacer()
            }
        }.padding()
            .frame(minHeight: 150, maxHeight: .infinity)

    }

    var keyString: String {
        keyWriter.openSSHString(secret: secret)
    }

    func copy() {
        NSPasteboard.general.declareTypes([.string], owner: nil)
        NSPasteboard.general.setString(keyString, forType: .string)
    }


}

#if DEBUG

struct SecretDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SecretDetailView(secret: Preview.Store(numberOfRandomSecrets: 1).secrets[0])
    }
}

#endif
