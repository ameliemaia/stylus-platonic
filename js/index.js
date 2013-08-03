var AudioPlayer, IndexView, delay,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

delay = function(ms, func) {
  return setTimeout(func, ms);
};

AudioPlayer = (function() {
  AudioPlayer.prototype.volume = 0;

  AudioPlayer.prototype.percent = 0;

  AudioPlayer.prototype.current_time = 0;

  function AudioPlayer(id) {
    this.id = id;
    this._on_time_update = __bind(this._on_time_update, this);
    this._on_audio_ended = __bind(this._on_audio_ended, this);
    this._on_audio_ready = __bind(this._on_audio_ready, this);
    this.play = __bind(this.play, this);
    this.setup = __bind(this.setup, this);
    this.on = new Object();
    this.on.timeupdate = new signals.Signal();
    this.on.loadedmetadata = new signals.Signal();
    this.on.ended = new signals.Signal();
    this.audio = document.getElementById(this.id);
  }

  AudioPlayer.prototype.setup = function() {
    this.audio.addEventListener('timeupdate', this._on_time_update);
    this.audio.addEventListener('loadedmetadata', this._on_audio_ready);
    return this.audio.addEventListener('ended', this._on_audio_ended);
  };

  AudioPlayer.prototype.get_duration = function() {
    return this.audio.duration;
  };

  AudioPlayer.prototype.get_current_time = function() {
    return this.audio.currentTime;
  };

  AudioPlayer.prototype.set_volume = function(volume) {
    this.volume = volume;
    return this.audio.volume = this.volume;
  };

  AudioPlayer.prototype.play = function() {
    return this.audio.play();
  };

  AudioPlayer.prototype._on_audio_ready = function() {
    if (this.on.loadedmetadata.getNumListeners() > 0) {
      return this.on.loadedmetadata.dispatch();
    }
  };

  AudioPlayer.prototype._on_audio_ended = function() {
    if (this.on.ended.getNumListeners() > 0) {
      return this.on.ended.dispatch();
    }
  };

  AudioPlayer.prototype._on_time_update = function() {
    this.current_time = this.get_current_time();
    this.percent = (this.current_time / this.get_duration()) * 100;
    if (this.on.timeupdate.getNumListeners() > 0) {
      return this.on.timeupdate.dispatch(this.percent);
    }
  };

  return AudioPlayer;

})();

IndexView = (function() {
  IndexView.prototype.percent = 0;

  IndexView.prototype.current_time = 0;

  IndexView.prototype.song = {
    credits: 'therall toge © hems'
  };

  function IndexView() {
    this.update_animation = __bind(this.update_animation, this);
    this.on_time_update = __bind(this.on_time_update, this);
    this.on_audio_ended = __bind(this.on_audio_ended, this);
    this.on_audio_ready = __bind(this.on_audio_ready, this);
    this.timeline = {
      '0': {
        "in": {
          'icosahedron': ['in-1']
        }
      },
      '17': {
        "in": {
          'dodecahedron': ['in-1', 'glitch-1'],
          'icosahedron': ['glitch-1']
        }
      },
      '31': {
        "in": {
          'icosahedron': ['out-1'],
          'dodecahedron': ['out-1'],
          'hexahedron': ['in-1']
        }
      },
      '47': {
        "in": {
          'octahedron': ['in-1']
        },
        out: {
          'icosahedron': ['in-1', 'glitch-1', 'out-1'],
          'dodecahedron': ['in-1', 'glitch-1', 'out-1']
        }
      },
      '66': {
        "in": {
          'tetrahedron': ['in-1'],
          'octahedron': ['out-1'],
          'hexahedron': ['out-1']
        }
      },
      '77': {
        "in": {
          'tetrahedron': ['glitch-1']
        }
      },
      '90': {
        "in": {
          'icosahedron': ['in-2', 'glitch-2']
        }
      },
      '91': {
        "in": {
          'dodecahedron': ['in-2', 'glitch-2']
        }
      },
      '92': {
        "in": {
          'octahedron': ['in-2', 'glitch-2']
        }
      },
      '93': {
        "in": {
          'hexahedron': ['in-2', 'glitch-2']
        }
      },
      '98': {
        out: {
          'icosahedron': ['in-2', 'glitch-2'],
          'dodecahedron': ['in-2', 'glitch-2'],
          'hexahedron': ['in-1', 'out-1', 'in-2', 'glitch-2'],
          'octahedron': ['in-1', 'out-1', 'in-2', 'glitch-2'],
          'tetrahedron': ['in-1', 'glitch-1']
        }
      }
    };
    this.gui_sound = window.gui.addFolder('Sound');
    this.player = new AudioPlayer('audio');
    this.player.on.loadedmetadata.addOnce(this.on_audio_ready);
    this.player.on.timeupdate.add(this.on_time_update);
    this.player.on.ended.add(this.on_audio_ended);
    this.player.set_volume(0.5);
    this.player.setup();
  }

  IndexView.prototype.on_audio_ready = function() {
    var _this = this;
    this.gui_sound.add(this.player, 'volume', 0, 1).onChange(function(e) {
      return _this.player.set_volume(e);
    });
    this.gui_sound.add(this.song, 'credits');
    this.gui_sound.open();
    return this.player.play();
  };

  IndexView.prototype.on_audio_ended = function() {
    var _this = this;
    return delay(2000, function() {
      return _this.player.play();
    });
  };

  IndexView.prototype.on_time_update = function(percent) {
    this.percent = percent;
    return this.update_animation();
  };

  IndexView.prototype.update_animation = function() {
    var cls, el, id, keyframe, method, obj, _i, _len, _ref;
    keyframe = Math.floor(this.percent);
    if (this.timeline[keyframe] && this.last_keyframe !== keyframe) {
      for (obj in this.timeline[keyframe]) {
        for (id in this.timeline[keyframe][obj]) {
          el = document.getElementById(id);
          if (obj === 'in') {
            method = 'addClass';
          } else {
            method = 'removeClass';
          }
          _ref = this.timeline[keyframe][obj][id];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            cls = _ref[_i];
            $(el)[method](cls);
          }
        }
      }
      return this.last_keyframe = keyframe;
    }
  };

  return IndexView;

})();

$(function() {
  return new IndexView();
});
