# Network Image Provider 
 `network_image.dart`, `network_image_state,dart`, `network_image_cubit.dart`
 
- receives a list of image url as string.
- return a list of images.
- cache the loaded images.
- returns an Icon if imgUrl not found.
- when refreshed, it removes previous cached image and cache a new image list.

` Manages the image state from loading, loaded and caching.`