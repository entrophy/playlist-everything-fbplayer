// Generated by CoffeeScript 1.6.2
(function() {
  var done, r, ready,
    _this = this;

  r = 0;

  done = function() {
    if (++r === 3) {
      return ready();
    }
  };

  define(['jquery', 'underscore', 'angular', 'youtube', 'facebook', 'soundcloud', 'mousetrap', 'jquery.xdomainajax'], function() {
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

    console.log('DONE \\o/ The fun can start');
    $('#preloader').hide();
    $('#wrapper').show();
    FB.init({
      appId: '228230950634896',
      channelUrl: '/fb-channel',
      status: true,
      cookie: true,
      xfbml: true
    });
    app = angular.module('PlaylistEverythingFacebookPlayer', []).config(function($locationProvider) {
      return $locationProvider.html5Mode(true);
    });
    app.service('FBService', _this.FBService);
    app.service('Queue', _this.Queue);
    app.controller('LoginCtrl', function($scope) {
      $scope.visible = false;
      FB.getLoginStatus(function(response) {
        if (response.status !== "connected") {
          return $scope.$apply(function() {
            return $scope.visible = true;
          });
        }
      });
      FB.Event.subscribe('auth.authResponseChange', function(response) {
        if (response.status !== "connected") {
          return $scope.$apply(function() {
            return $scope.visible = true;
          });
        }
      });
      return $scope.login = function() {
        FB.login(function(response) {
          if (response.status === "connected") {
            return $scope.visible = false;
          }
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
        }
      });
    });
    app.controller('UserCtrl', function($scope) {
      $scope.user = {};
      return FB.Event.subscribe('auth.authResponseChange', function(response) {
        if (response.status === "connected") {
          return FB.api('/me', function(response) {
            return $scope.$apply(function() {
              return $scope.user = response;
            });
          });
        }
      });
    });
    app.controller('PageCtrl', function($scope) {
      return $scope.page = [];
    });
    app.controller('GroupCtrl', function($scope, $rootScope) {
      $scope.group = null;
      $scope.groups = [];
      $scope.test = 'no';
      FB.Event.subscribe('auth.authResponseChange', function(response) {
        if (response.status === "connected") {
          return FB.api('/me/groups', function(response) {
            return $scope.$apply(function() {
              return $scope.groups = response.data;
            });
          });
        }
      });
      return $scope.select = function(group) {
        return $rootScope.$broadcast('selectGroup', group);
      };
    });
    app.controller('InfoCtrl', function($scope) {
      $scope.title = '';
      $scope.description = '';
      return $scope.$on('selectGroup', function(event, group) {
        $scope.title = group.name;
        $scope.description = '';
        return console.log("her");
      });
    });
    app.controller('QueueCtrl', function($scope) {});
    app.controller('PlayerCtrl', function($scope) {});
    app.controller('PageCtrl', function($scope, $http, $rootScope, $location, FBService, Queue) {
      var _this = this;

      console.log(" --> PageCtrl");
      $scope.page = null;
      $scope.url = $location.absUrl().split('/').pop();
      ($scope.resetVisibility = function() {
        $scope.visible = {};
        $scope.visible.invalid = false;
        $scope.visible["private"] = false;
        $scope.visible.page = false;
        $scope.visible.search = true;
        return $scope.visible.loading = false;
      })();
      $scope.login = function() {
        FB.login(function(response) {
          console.log("here new:");
          console.log(response);
          if (response.status === "connected") {
            return $scope.loadPage();
          }
        });
        return false;
      };
      $scope.loadPage = function() {
        $scope.resetVisibility();
        $scope.visible.loading = true;
        $scope.$apply();
        FBService.setPageUrl($scope.url);
        FBService.getPage(function(err, page) {
          if (err === "invalid") {
            $scope.visible.invalid = true;
          } else if (err === "private") {
            $scope.visible["private"] = true;
          } else {
            $scope.visible.search = false;
            $scope.visible.page = true;
            $scope.page = page;
            $location.path(page.link.split('/').pop());
            $location.replace();
            $rootScope.$broadcast("loadPosts");
          }
          $scope.visible.loading = false;
          return $scope.$apply();
        });
        return false;
      };
      return $scope.unloadPage = function() {
        FBService.clear();
        $scope.page = null;
        $scope.resetVisibility();
        $('#url-search').focus();
        $rootScope.$broadcast("uploadPosts");
        return false;
      };
    });
    app.controller('SongCtrl', function($scope, $rootScope, FBService, Queue) {
      var _this = this;

      console.log(" --> SongCtrl");
      $scope.songs = [];
      ($scope.resetVisibility = function() {
        $scope.visible = {};
        $scope.visible.loading = false;
        return $scope.visible.more = false;
      })();
      Queue.on('add', function(song) {
        $scope.songs = Queue.getAllSongs();
        return $scope.$apply();
      });
      $scope.$on('loadPosts', function() {
        return $scope.loadPosts();
      });
      $scope.$on('uploadPosts', function() {
        return $scope.unloadPosts();
      });
      $scope.loadPosts = function() {
        var len;

        if (!$scope.visible.loading) {
          $scope.visible.more = false;
          $scope.visible.loading = true;
          len = $scope.songs.length;
          FBService.getPosts(function(err, posts) {
            var post, song, _i, _len;

            for (_i = 0, _len = posts.length; _i < _len; _i++) {
              post = posts[_i];
              song = new Song(post);
              if (song.playable) {
                Queue.add(song);
              }
            }
            $scope.visible.loading = false;
            $scope.visible.more = len < $scope.songs.length;
            return $scope.$apply();
          });
        }
        return false;
      };
      return $scope.unloadPosts = function() {
        Queue.clear();
        $scope.resetVisibility();
        return false;
      };
    });
    app.controller('ControlsCtrl', function($scope, Queue) {
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
      return Mousetrap.bind('left', function() {
        Queue.prev();
        return false;
      });
    });
    return angular.bootstrap(document, ['PlaylistEverythingFacebookPlayer']);
  };

}).call(this);
