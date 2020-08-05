;(function () {
  'use strict';

  const angular = window.angular;

  Runner.$inject = [
    '$templateCache'
  ];

  angular
    .module('app')
    .run(Runner);

  function Runner ($templateCache) {

    $templateCache.put('template/time-picker.html',
      `<ul class="dropdown-menu dropdown-menu-left datetime-picker-dropdown" ng-show="isOpen && showPicker === 'time'"
            ng-style="dropdownStyle" style="left:inherit" ng-keydown="keydown($event)" ng-click="$event.preventDefault(); $event.stopPropagation()">
            <li style="padding:0 5px 5px 5px" class="time-picker-menu">
                <div ng-transclude></div>
            </li>
            <li style="padding:5px" ng-if="buttonBar.show">
              <span class="btn-group pull-left" style="margin-right:10px" ng-if="doShow('now') || doShow('clear')">
                  <button type="button" class="btn" ng-class="getClass('now')" ng-if="doShow('now')" 
                          ng-click="select('now', $event)" ng-disabled="isDisabled('now')">{{ getText('now') }}
                  </button> 
                  <button type="button" class="btn" ng-class="getClass('clear')" ng-if="doShow('clear')" 
                          ng-click="select('clear', $event)">{{ getText('clear') }}
                  </button>
              </span>
              <span class="btn-group pull-right" ng-if="(doShow('date') && enableDate) || doShow('close') || doShow('cancel')">
                  <button type="button" class="btn" ng-class="getClass('date')" ng-if="doShow('date') && enableDate" ng-click="open('date', $event)">{{ getText('date')}}</button>
                  <button type="button" class="btn" ng-class="getClass('close')" ng-if="doShow('close')" ng-click="close(true, $event)">{{ getText('close') }}</button> 
                  <button type="button" class="btn" ng-class="getClass('cancel')" ng-if="doShow('cancel')" ng-click="cancel($event)">{{ getText('cancel') }}</button>
              </span> 
              <span class=clearfix></span>
            </li>
      </ul>`
    );

    $templateCache.put('template/date-picker.html',
      `<ul class="dropdown-menu dropdown-menu-left datetime-picker-dropdown" ng-show="isOpen && showPicker === 'date'" ng-style="dropdownStyle" style="left:inherit" ng-click="$event.preventDefault(); $event.stopPropagation()">
            <li style="padding:0 5px 5px 5px" class="date-picker-menu">
                <div ng-transclude></div>
            </li>
            <li style="padding:5px" ng-if="buttonBar.show">
                <span class="btn-group pull-left" style="margin-right:10px" ng-if="doShow('today') || doShow('clear')">
                    <button type="button" class="btn" ng-class="getClass('today')" ng-if="doShow('today')" ng-click="select('today', $event)" ng-disabled="isDisabled('today')">{{ getText('today') }}</button>
                    <button type="button" class="btn" ng-class="getClass('clear')" ng-if="doShow('clear')" ng-click="select('clear', $event)">{{ getText('clear') }}</button>
                </span> 
                <span class="btn-group pull-right" ng-if="(doShow('time') && enableTime) || doShow('close') || doShow('cancel')">
                    <button type="button" class="btn" ng-class="getClass('time')" ng-if="doShow('time') && enableTime" ng-click="open('time', $event)">{{ getText('time')}}</button>
                    <button type="button" class="btn" ng-class="getClass('close')" ng-if="doShow('close')" ng-click="close(true, $event)">{{ getText('close') }}</button> 
                    <button type="button" class="btn" ng-class="getClass('cancel')" ng-if="doShow('cancel')" ng-click="cancel($event)">{{ getText('cancel') }}</button>
                </span> 
                <span class=clearfix></span>
            </li>
      </ul>`
    );
  }
})();
