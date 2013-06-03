angular.module('directives', [])
  .directive('stopEvent', function () {
    return function (scope, element, attr) {
      element.bind(attr.stopEvent, function (e) {
          e.stopPropagation();
      });
    };
  }).directive('collapseOnClick', function() {
    return function (scope, element, attr) {
      element.bind('click', function(){ $(this).slideUp("slow") });
    };
  });