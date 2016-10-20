A container view controller manages its own views plus the root views from one or more of its child view controllers. The container does not manage the content of its children.It manages only the root view, sizing and placing it according to the container’s design.

**容器视图控制器的实现**

容器视图控制器是一种组合多个视图控制器的内容到单一用户界面的方式。一个容器控制器像其他的内容视图控制器一样，管理着一个root view和一些内容，不同之处是它的部分内容从其他视图控制器获得。它获得的内容被限制在子视图控制器的views中，它将这些views嵌入到自己的view 层级中。容器视图控制器设置任何嵌入的视图的尺寸和位置，但是原始的视图控制器仍然管理这些视图里的内容。

容器试图控制器的实现是相当简单的，只需要建立正式的父子关系。父子关系的建立确保子控制器能够接收任何相关的系统消息。除此之外，在布局和管理包含的视图的大部分工作对不同容器是不同的。

示例：导航控制器(Navigation Controller) 和 Split View Controller.....

**在IB中配置一个Container**

xib中有个Container View控件，他是一个占位对象，表示一个子视图控制器的内容。使用该container view视图来调整子视图控制器的root view在容器中的位置和大小。

**代码实现自定义container view controller**

要实现一个容器视图控制器，必须将你的view controller与它的子视图控制器建立联系。

**Adding a Child View Controller to Your Content**

要将一个子视图控制器添加到你的内容中，相关的视图控制器间创建父子关系，方法如下 ：

1.  Call the `addChildViewController:` method of your container view controller.
	This method tells UIKit that your container view controller is now managing the view of the child view controller.
2. Add the child’s root view to your container’s view hierarchy. Always remember to set the size and position of the child’s frame as part of this process. 
3. Add any constraints for managing the size and position of the child’s root view.
4. Call the `didMoveToParentViewController:` method of the child view controller. 

	After establishing the parent-child relationship, the container sets the frame of its child and adds the child’s view to its own view hierarchy. Setting the frame size of the child’s view is important and ensures that the view shows up correctly in your container. After adding the view, the container calls the child’s `didMoveToParentViewController:` method to give the child view controller a chance to respond to the change in view ownership.
	
~~~objc

- (void) displayContentController: (UIViewController*) content {
     [self addChildViewController:content];
     content.view.frame = [self frameForContentController];
     [self.view addSubview:self.currentClientView];
     [content didMoveToParentViewController:self];
 }
~~~

In the preceding example, notice that you call only the `didMoveToParentViewController:` method of the child. That is because the `addChildViewController:` method calls the child’s `willMoveToParentViewController:` method for you. The reason that you must call the `didMoveToParentViewController:` method yourself is that the method cannot be called until after you embed the child’s view into your container’s view hierarchy. 

When using Auto Layout, set up constraints between the container and child after adding the child to the container’s view hierarchy. Your constraints should affect the size and position of only the child’s root view. Do not alter the contents of the root view or any other views in the child’s view hierarchy

**移除子视图控制器**

要从你的content移除一个子视图控制器，移除视图控制器间的父子关系，方法如下：

1. Call the child’s `willMoveToParentViewController:` method with the value `nil`.
2. Remove any constraints that you configured with the child’s root view.
3. Remove the child’s root view from your container’s view hierarchy.
4. Call the child’s `removeFromParentViewController` method to finalize the end of the parent-child relationship.

移除子视图控制器，永久切断父子关系。只有当你不再需要引用一个子视图控制器时，才移除子视图控制器。例如，一个导航控制器，当一个新的视图控制器push到导航的栈中时，不会移除它的当前的子视图控制器。只有当他们被pop off栈时，才会被移除。

例子：Calling the `willMoveToParentViewController:` method with the value `nil` gives the child view controller an opportunity to prepare for the change. The `removeFromParentViewController` method also calls the child’s `didMoveToParentViewController:` method, passing that method a value of nil. Setting the parent view controller to nil finalizes the removal of the child’s view from your container.

~~~objc
- (void) hideContentController: (UIViewController*) content {
   [content willMoveToParentViewController:nil];
   [content.view removeFromSuperview];
   [content removeFromParentViewController];
}
~~~

**子视图控制器间的过渡**

当你想在从一个视图控制器切换到另一个视图控制器间进行动画，将子视图控制器的添加和删除纳入到过渡动画过程中。在进行动画之前，确保两个视图控制器都是你的content的一部分，但让当前子视图控制器得知即将离开(go away).在动画期间，移动新的子视图控制器的view到指定位置，并移走旧的子视图控制器的view。在动画完成时，完成子视图控制器的移除。

示例:shows an example of how to swap one child view controller for another using a transition animation. In this example, the new view controller is animated to the rectangle currently occupied by the existing child view controller, which is moved offscreen. After the animations finish, the completion block removes the child view controller from the container. In this example, the `transitionFromViewController:toViewController:duration:options:animations:completion:` method automatically updates the container’s view hierarchy, so you do not need to add and remove the views yourself.

~~~objc
- (void)cycleFromViewController: (UIViewController*) oldVC
               toViewController: (UIViewController*) newVC {
   // Prepare the two view controllers for the change.
   [oldVC willMoveToParentViewController:nil];
   [self addChildViewController:newVC];
 
   // Get the start frame of the new view controller and the end frame
   // for the old view controller. Both rectangles are offscreen.
   newVC.view.frame = [self newViewStartFrame];
   CGRect endFrame = [self oldViewEndFrame];
 
   // Queue up the transition animation.
   [self transitionFromViewController: oldVC toViewController: newVC
        duration: 0.25 options:0
        animations:^{
            // Animate the views to their final positions.
            newVC.view.frame = oldVC.view.frame;
            oldVC.view.frame = endFrame;
        }
        completion:^(BOOL finished) {
           // Remove the old view controller and send the final
           // notification to the new view controller.
           [oldVC removeFromParentViewController];
           [newVC didMoveToParentViewController:self];
        }];
}
~~~

**管理子视图控制器的外观更新**

在添加了一个child到container后，container自动转发外观相关的消息给child.这确保了所有的事件能被正确的发送。然而，有时候这种默认的行为可能以一种对你的container来说并不合理的顺序发送那些事件。

要接管appearance callbacks，需要在container view controler中重写方法`shouldAutomaticallyForwardAppearanceMethods`方法，返回`NO`。

Disabling automatic appearance forwarding

~~~objc
- (BOOL) shouldAutomaticallyForwardAppearanceMethods {
        return NO;
}
~~~



