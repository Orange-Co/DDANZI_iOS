//
//  KakaoPostCodeViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/9/24.
//

import UIKit
import WebKit

import RxSwift

class KakaoPostCodeViewController: UIViewController {
  
  private var webView: WKWebView = WKWebView()
  private var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .white
    setupActivityIndicator()
    setupWebView()
    
    setUI()
  }
  
  private func setUI() {
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    view.addSubview(webView)
  }
  
  private func setConstraints() {
    webView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func setupActivityIndicator() {
    activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.center = view.center
    activityIndicator.hidesWhenStopped = true // 중지 시 숨김
    view.addSubview(activityIndicator)
  }
  
  private func setupWebView() {
    let gitURL = URL(string: "https://zoe0929.github.io/Kakao-postcodeWebView/")!
    let request = URLRequest(url: gitURL)
    let configure = WKWebViewConfiguration()
    let contentController = WKUserContentController()
    configure.userContentController = contentController
    
    webView = WKWebView(frame: UIScreen.main.bounds, configuration: configure)
    webView.navigationDelegate = self
    webView.load(request)
  }
}

extension KakaoPostCodeViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    activityIndicator.startAnimating()
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    activityIndicator.stopAnimating()
  }
  
  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    activityIndicator.stopAnimating()
  }
}

extension KakaoPostCodeViewController: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
  }
}
