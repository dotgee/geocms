/**
 * @name ui.geocms.textselect
 *
 * @description
 * Mouse select text when clicking on element
 * Useful for values meant to be copy/pasted
 *
 */

angular.module('ui.geocms.textselect', [])

.directive('textSelect', function() {
  return {
    restrict: 'A',
    link: function (scope, element, attrs) {
      element.on('click', function () {
        this.select();
      });
    }
  };
});