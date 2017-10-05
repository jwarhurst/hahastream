import UIKit
import AVKit

class VCSViewController: HahaSplitViewController, UISplitViewControllerDelegate, VCSChannelListDelegate {
	var activeVCS: VCS?;
	var playerViewController: AVPlayerViewController? {
		return self.viewControllers.last as? AVPlayerViewController
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.delegate = self
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func vcsChannelListDidFocus(vcs: VCS) {
	}


	func vcsChannelListDidSelect(vcs: VCS) {
		let __FIXME_REIMPLEMENT_THIS: Any?
//		if vcs.uuid == activeVCS?.uuid {
//
//		}
//		activeVCS = vcs;
//		provider.getVCSStreams(vcs: vcs, success: { (streams) in
//			if streams.count > 0 {
//				if( self.activeVCS?.uuid == vcs.uuid ) {
//					DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//						if( self.activeVCS?.uuid == vcs.uuid ) {
//							self.previewURL(streams.first!.url)
//						}
//					}
//				}
//			}
//		}, apiError: { (error) in
//			print(error)
//		}) { (error) in
//			print(error)
//		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.playerViewController?.player?.pause()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.playerViewController?.player?.play()
	}

	override var preferredFocusEnvironments: [UIFocusEnvironment] {
		var def = super.preferredFocusEnvironments;
		if let masterVC = self.viewControllers.first {
			//make sure the master vc is first (this is an issue after escaping from fullscreen avplayer)
			def.insert(masterVC, at: 0)
		}
		return def;
	}
	
	override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
		//print("shouldUpdateFocus: \(context.previouslyFocusedView) => \(context.nextFocusedView)")
		let def = super.shouldUpdateFocus(in: context);
		if context.previouslyFocusedView is VCSChannelListCell &&
			context.focusHeading == .right {
			return self.playerViewController != nil
		}
		else {
			return def
		}
	}

	override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
		//print("didUpdateFocus: \(context.previouslyFocusedView) => \(context.nextFocusedView)")

		if context.previouslyFocusedView is VCSChannelListCell &&
			context.focusHeading == .right {
			if self.playerViewController != nil {
				coordinator.addCoordinatedAnimations({ 
					self.preferredDisplayMode = .primaryHidden
				}, completion: nil)
			}
		}
	}
	
	

	func previewURL(_ url: URL) {
		// Create an AVPlayer, passing it the HTTP Live Streaming URL.
		let player = AVPlayer(url: url)
		
		// Create a new AVPlayerViewController and pass it a reference to the player.
		player.play()
		
		if let controller = self.playerViewController {
			controller.player = player
		}
		else {
			let controller = AVPlayerViewController()
			controller.player = player
			self.showDetailViewController(controller, sender: nil)
		}
	}
	
	//MARK - UISplitViewControllerDelegate
	
	 public func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewControllerDisplayMode)
	{
		//print("willChangeTo \(displayMode.rawValue)")
		if( displayMode == .allVisible ) {
			self.setNeedsFocusUpdate()
			self.updateFocusIfNeeded()
		}
	}
}
