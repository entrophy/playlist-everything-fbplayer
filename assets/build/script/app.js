var done, r, ready,
  _this = this;

r = 0;

done = function() {
  if (++r === 3) {
    return ready();
  }
};

define(['jquery', 'underscore', 'angular', 'youtube', 'facebook', 'soundcloud', 'mousetrap'], function() {
  return $(document).ready(function() {
    return done();
  });
});

window.onYouTubeIframeAPIReady = function() {
  return done();
};

window.fbAsyncInit = function() {
  return done();
};

ready = function() {
  var app;

  app = angular.module('PlaylistEverythingFacebookPlayer', []).config(function($locationProvider) {
    return $locationProvider.html5Mode(true);
  });
  app.service('FBService', _this.FBService);
  app.service('Queue', _this.Queue);
  FB.init({
    appId: '228230950634896',
    channelUrl: '/fb-channel',
    status: true,
    cookie: true,
    xfbml: true
  });
  FB.getLoginStatus(function(response) {
    $('#preloader').hide();
    return $('#wrapper').show();
  });
  app.controller('LoginCtrl', function($scope) {
    $scope.visible = false;
    FB.getLoginStatus(function(response) {
      if (response.status !== "connected") {
        return $scope.$apply(function() {
          return $scope.visible = true;
        });
      } else {
        return $scope.$apply(function() {
          return $scope.visible = false;
        });
      }
    });
    FB.Event.subscribe('auth.authResponseChange', function(response) {
      if (response.status !== "connected") {
        return $scope.$apply(function() {
          return $scope.visible = true;
        });
      } else {
        return $scope.$apply(function() {
          return $scope.visible = false;
        });
      }
    });
    return $scope.login = function() {
      FB.login(function(response) {
        if (response.status === "connected") {
          return $scope.visible = false;
        }
      }, {
        scope: 'user_groups'
      });
      return false;
    };
  });
  app.controller('AppCtrl', function($scope) {
    $scope.visible = false;
    return FB.Event.subscribe('auth.authResponseChange', function(response) {
      if (response.status === "connected") {
        return $scope.$apply(function() {
          return $scope.visible = true;
        });
      } else {
        return $scope.$apply(function() {
          return $scope.visible = false;
        });
      }
    });
  });
  app.controller('PageCtrl', function($scope, $rootScope, FBService) {
    var _this = this;

    $scope.url = '';
    ($scope.resetVisibility = function() {
      $scope.visible = {};
      $scope.visible.all = true;
      $scope.visible.invalid = false;
      return $scope.visible.loading = false;
    })();
    $scope.selectPage = function() {
      if ($scope.url) {
        $scope.resetVisibility();
        $scope.visible.loading = true;
        FBService.setType('page');
        FBService.setUrl($scope.url);
        FBService.getPage(function(err, page) {
          return $scope.$apply(function() {
            $scope.visible.loading = false;
            if (err === "invalid") {
              return $scope.visible.invalid = true;
            } else {
              $scope.visible.all = false;
              return $rootScope.$broadcast("selectPage", page);
            }
          });
        });
      }
      return false;
    };
    $scope.$on('select', function() {
      $scope.resetVisibility();
      return $scope.visible.all = false;
    });
    return $scope.$on('deselect', function() {
      return $scope.resetVisibility();
    });
  });
  app.controller('GroupCtrl', function($scope, $rootScope, FBService) {
    $scope.groups = [];
    ($scope.resetVisibility = function() {
      $scope.visible = {};
      $scope.visible.all = true;
      return $scope.visible.loading = false;
    })();
    FB.Event.subscribe('auth.authResponseChange', function(response) {
      if (response.status === "connected") {
        $scope.$apply(function() {
          return $scope.visible.loading = true;
        });
        return FBService.getGroups(function(err, groups) {
          return $scope.$apply(function() {
            $scope.visible.loading = false;
            return $scope.groups = groups;
          });
        });
      } else {
        return $scope.$apply(function() {
          return $scope.visible.loading = false;
        });
      }
    });
    $scope.selectGroup = function(group) {
      $scope.visible.all = false;
      FBService.setType('group');
      FBService.setUrl(group.id);
      return $rootScope.$broadcast('selectGroup', group);
    };
    $scope.$on('select', function() {
      $scope.resetVisibility();
      return $scope.visible.all = false;
    });
    return $scope.$on('deselect', function() {
      return $scope.resetVisibility();
    });
  });
  app.controller('InfoCtrl', function($scope, $rootScope) {
    $scope.visible = false;
    $scope.title = '';
    $scope.description = '';
    $scope.$on('selectGroup', function(event, group) {
      $scope.title = group.name;
      $scope.description = '';
      $scope.visible = true;
      return $rootScope.$broadcast('select');
    });
    $scope.$on('selectPage', function(event, page) {
      $scope.title = page.name;
      $scope.description = page.about;
      $scope.visible = true;
      return $rootScope.$broadcast('select');
    });
    return $scope.deselect = function() {
      $scope.visible = false;
      return $rootScope.$broadcast('deselect');
    };
  });
  app.controller('QueueCtrl', function($scope, FBService, Queue) {
    ($scope.resetVisibility = function() {
      $scope.visible = {};
      $scope.visible.all = false;
      $scope.visible.loading = false;
      return $scope.visible.more = false;
    })();
    $scope.songs = [];
    $scope.current = 0;
    $scope.loadSongs = function() {
      var len;

      if (!$scope.visible.loading) {
        $scope.visible.more = false;
        $scope.visible.loading = true;
        len = $scope.songs.length;
        return FBService.getItems(function(err, items) {
          var item, song, _i, _len;

          for (_i = 0, _len = items.length; _i < _len; _i++) {
            item = items[_i];
            song = new Song(item);
            if (song.playable) {
              Queue.add(song);
            }
          }
          return $scope.$apply(function() {
            $scope.visible.loading = false;
            return $scope.visible.more = len < $scope.songs.length;
          });
        });
      }
    };
    $scope.play = function(index) {
      return Queue.playByIndex(index);
    };
    $scope.pause = function() {
      return Queue.pause();
    };
    Queue.on('add', function(song) {
      return $scope.$apply(function() {
        return $scope.songs = Queue.getAllSongs();
      });
    });
    Queue.on('change', function(index) {
      return $scope.current = index;
    });
    Queue.on('last', function() {
      return $scope.$apply(function() {
        return $scope.loadSongs();
      });
    });
    $scope.$on('selectPage', function(event, page) {
      $scope.visible.all = true;
      return $scope.loadSongs();
    });
    $scope.$on('selectGroup', function(event, group) {
      $scope.visible.all = true;
      return $scope.loadSongs();
    });
    return $scope.$on('deselect', function(event) {
      $scope.resetVisibility();
      Queue.clear();
      return FBService.clear();
    });
  });
  app.controller('ControlsCtrl', function($scope, Queue) {
    $scope.visible = false;
    $scope.play = function() {
      return Queue.play();
    };
    $scope.pause = function() {
      return Queue.pause();
    };
    $scope.stop = function() {
      return Queue.stop();
    };
    $scope.next = function() {
      return Queue.next();
    };
    $scope.prev = function() {
      return Queue.prev();
    };
    Mousetrap.bind('space', function() {
      Queue.playOrPause();
      return false;
    });
    Mousetrap.bind('right', function() {
      Queue.next();
      return false;
    });
    Mousetrap.bind('left', function() {
      Queue.prev();
      return false;
    });
    $scope.$on('select', function(event) {
      return $scope.visible = true;
    });
    return $scope.$on('deselect', function(event) {
      return $scope.visible = false;
    });
  });
  return angular.bootstrap(document, ['PlaylistEverythingFacebookPlayer']);
};
