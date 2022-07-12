import Foundation
import Flutter
import ContactsUI

enum NativeCallBackType: String {
    case openContactsView = "open_contacts_view"

    var nativeProcedure: (_ call: FlutterMethodCall, _ result: FlutterResult) -> Void {
        switch self {
        case .openContactsView:
            return OpenContactsView.instance.nativeProcedure
        }
    }
}

protocol NativeCallBackDelegate {
    func nativeProcedure(_ call: FlutterMethodCall, _ result: FlutterResult) -> Void
}

class NativeCallBackBase: NSObject {
    var flutterRootVC: FlutterViewController {
        guard let appDelegate = UIApplication.shared.delegate else {
            // WARNING: 想定外
            print("\(String(describing: Self.self))::\(#function)@\(#line)")
            return FlutterViewController()
        }
        guard let window = appDelegate.window else {
            // WARNING: 想定外
            print("\(String(describing: Self.self))::\(#function)@\(#line)")
            return FlutterViewController()
        }
        guard let flutterVC = window?.rootViewController as? FlutterViewController else {
            // WARNING: 想定外
            print("\(String(describing: Self.self))::\(#function)@\(#line)")
            return FlutterViewController()
        }
        print("\(String(describing: Self.self))::\(#function)@\(#line)")
        return flutterVC
    }
}

class OpenContactsView: NativeCallBackBase, NativeCallBackDelegate {
    static let instance: OpenContactsView = OpenContactsView()
    private override init() {
        super.init()
    }

    func nativeProcedure(_ call: FlutterMethodCall, _ result: FlutterResult) {
        print("\(String(describing: Self.self))::\(#function)@\(#line)")
        let flutterRootVC = flutterRootVC
        let contactVC = CNContactViewController(forNewContact: nil)
        contactVC.delegate = self
        let navigationController = UINavigationController(rootViewController: contactVC)
        navigationController.modalPresentationStyle = .fullScreen
        flutterRootVC.present(navigationController, animated: true)
    }
}

extension OpenContactsView: CNContactViewControllerDelegate {
    public func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        print("\(String(describing: Self.self))::\(#function)@\(#line)"
            + "contact: \(contact)"
        )
        // TODO: 保存はこのままネイティブで行うか、回りくどいが Flutter へ戻ってプラグイン経由で保存するなどする。
        // NOTE: contact が nil の場合はキャンセル
        viewController.dismiss(animated: true)
    }
}

