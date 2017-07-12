import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
  let captureSession = AVCaptureSession();
  var previewLayer: AVCaptureVideoPreviewLayer?
  var captureDevice: AVCaptureDevice?
  
  // 読み取り範囲（0 ~ 1.0の範囲で指定）
  let x: CGFloat = 0.1
  let y: CGFloat = 0.4
  let width: CGFloat = 0.8
  let height: CGFloat = 0.2
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // カメラがあるか確認し，取得する
    captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
//    let inputDevice = AVCaptureDeviceInput(device: self.captureDevice, error: &error)
//    var input = AVCaptureDeviceInput()
    do {
      let input = try AVCaptureDeviceInput(device: captureDevice)
      captureSession.addInput(input)
    } catch {
      print("しくった")
      print(error)
      return
    }
    
//       Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
//    let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
//    
//    do {
//      // Get an instance of the AVCaptureDeviceInput class using the previous device object.
//      let input = try AVCaptureDeviceInput(device: captureDevice)
//      
//      // Initialize the captureSession object.
//      captureSession = AVCaptureSession()
//      
//      // Set the input device on the capture session.
//      captureSession?.addInput(input)
//      
//    } catch {
//      // If any error occurs, simply print it out and don't continue any more.
//      print(error)
//      return
//    }
    
    // カメラからの取得映像を画面全体に表示する
    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
    previewLayer?.frame = CGRectMake(0, 0, view.bounds.width, view.bounds.height)
    view.layer.insertSublayer(previewLayer!, at: 0)
    
    // metadata取得に必要な初期設定
    let metaOutput = AVCaptureMetadataOutput();
    metaOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main);
    captureSession.addOutput(metaOutput);
    
    // どのmetadataを取得するか設定する
    metaOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN13Code];
    
    // どの範囲を解析するか設定する
    metaOutput.rectOfInterest = CGRectMake(y, 1-x-width, height, width)
    
    // 解析範囲を表すボーダービューを作成する
    let borderView = UIView(frame: CGRectMake(x * view.bounds.width, y * view.bounds.height, width * view.bounds.width, height * view.bounds.height))
    borderView.layer.borderWidth = 2
    borderView.layer.borderColor = UIColor.red.cgColor
    view.addSubview(borderView)
    
    // capture session をスタートする
    captureSession.startRunning()
  }
  
  func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
    return CGRect(x: x, y: y, width: width, height: height)
  }
  
  // 映像からmetadataを取得した場合に呼び出されるデリゲートメソッド
  private func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
    
    // metadataが複数ある可能性があるためfor文で回す
    for data in metadataObjects {
      if data.type == AVMetadataObjectTypeEAN13Code {
        // 読み取りデータの全容をログに書き出す
        print("読み取りデータ：\(data)")
//        print("データの文字列：\(data.stringValue)")
        print("データの位置：\(data.bounds)")
      }
    }
  }
}
