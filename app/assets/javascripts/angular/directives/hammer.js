angular.module('directives', [])
  .directive('onTap', function () {
    return function (scope, element, attrs) {
      return $(element).hammer({
          prevent_default: false,
          drag_vertical: false
        })
        .bind("tap", function (ev) {
           return scope.$apply(attrs['onTap']);
      });
    }
  }).directive('stopEvent', function () {
    return function (scope, element, attr) {
      element.bind(attr.stopEvent, function (e) {
          e.stopPropagation();
      });
    };
  });