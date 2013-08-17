var Camera,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Camera = (function() {
  /*
  @private
  */

  Camera.prototype._$objects = Array;

  Camera.prototype._mouse = {
    x: 0,
    y: 0,
    lx: 0,
    ly: 0
  };

  Camera.prototype._dragging = false;

  /*
  @public
  */


  Camera.prototype.config = {
    perspective: 0,
    rotation_x: -30,
    rotation_y: -45,
    max_rotation_x: 360,
    max_rotation_y: 360
  };

  Camera.prototype.el = null;

  Camera.prototype.width = 0;

  Camera.prototype.height = 0;

  Camera.prototype.perspective = 0;

  Camera.prototype.rotation_x = 0;

  Camera.prototype.rotation_y = 0;

  Camera.prototype.rotation_lock_x = 0;

  Camera.prototype.rotation_lock_y = 0;

  Camera.prototype.gimball_radius = 100;

  /*
  constructor
  @param {$element} el
  */


  function Camera(el, config) {
    var _this = this;
    this.el = el;
    if (config == null) {
      config = {};
    }
    this._update_viewport = __bind(this._update_viewport, this);
    this.reset = __bind(this.reset, this);
    this.config = $.extend(this.config, config);
    this.config.perspective = parseFloat(this.el.css('perspective'));
    this.perspective = this.config.perspective;
    this._$objects = $('[data-camera-transform="1"]');
    this.el.mousemove(function(event) {
      return _this._on_mouse_move(event);
    });
    this.el.mouseup(function(event) {
      return _this._on_mouse_up(event);
    });
    this.el.mousedown(function(event) {
      return _this._on_mouse_down(event);
    });
    Hammer(this.el[0]).on('drag', function(event) {
      return _this._on_mouse_move(event);
    });
    Hammer(this.el[0]).on('touch', function(event) {
      return _this._on_mouse_down(event);
    });
    Hammer(this.el[0]).on('end', function(event) {
      return _this._on_mouse_up(event);
    });
    this._update_viewport(this.config.rotation_x, this.config.rotation_y);
  }

  /*
  Update the camera
  */


  Camera.prototype.update = function() {
    var dist_x, dist_y, pct_x, pct_y, rx, ry;
    this.el.css('perspective', this.perspective + 'px');
    if (this._dragging) {
      dist_x = this._mouse.x - this._mouse.lx;
      dist_y = this._mouse.ly - this._mouse.y;
      pct_x = dist_x / this.gimball_radius;
      pct_y = dist_y / this.gimball_radius;
      pct_x *= 0.1;
      pct_y *= 0.1;
      rx = this._rotation_lock_x + (this.config.max_rotation_x * pct_y);
      ry = this._rotation_lock_y + (this.config.max_rotation_y * pct_x);
      if (ry > 360) {
        ry -= 360;
      } else if (ry < -360) {
        ry += 360;
      }
      if (rx > 360) {
        rx -= 360;
      } else if (rx < -360) {
        rx += 360;
      }
      return this._update_viewport(rx, ry);
    }
  };

  /*
  Resize the viewport
  */


  Camera.prototype.resize = function() {
    this.width = this.el.width();
    return this.height = this.el.height();
  };

  /*
  Reset the viewport rotation
  */


  Camera.prototype.reset = function() {
    return this._update_viewport(this.config.rotation_x, this.config.rotation_y);
  };

  /*
  Update the viewport
  @param {Number} rotation_x
  @param {Number} rotation_y
  */


  Camera.prototype._update_viewport = function(rotation_x, rotation_y) {
    var object, transform, _i, _len, _ref;
    this.rotation_x = rotation_x;
    this.rotation_y = rotation_y;
    _ref = this._$objects;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      object = _ref[_i];
      transform = "rotateX(" + this.rotation_x + "deg) rotateY(" + this.rotation_y + "deg)";
      $(object).css({
        '-webkit-transform': transform,
        'transform': transform
      });
    }
    return false;
  };

  /*
  Viewport mouse move handler
  @param {Object} event
  */


  Camera.prototype._on_mouse_move = function(event) {
    var position;
    position = this._get_event_position(event);
    this._mouse.x = position.x;
    return this._mouse.y = position.y;
  };

  /*
  Viewport mouse down handler
  @param {Object} event
  */


  Camera.prototype._on_mouse_down = function(event) {
    var position;
    if (event.hasOwnProperty('gesture')) {
      event.gesture.preventDefault();
    }
    this._dragging = true;
    position = this._get_event_position(event);
    this._mouse.lx = position.x;
    this._mouse.ly = position.y;
    this._rotation_lock_x = this.rotation_x;
    this._rotation_lock_y = this.rotation_y;
    return this.el.css('cursor', '-webkit-grabbing');
  };

  /*
  Viewport mouse up handler
  @param {Object} event
  */


  Camera.prototype._on_mouse_up = function(event) {
    this._dragging = false;
    return this.el.css('cursor', 'inherit');
  };

  /*
  Get the touch / mouse position and return the coords
  @param  {Object} event
  @return {Object}
  */


  Camera.prototype._get_event_position = function(event) {
    var evt_x, evt_y;
    if (event.hasOwnProperty('gesture')) {
      evt_x = event.gesture.center.pageX;
      evt_y = event.gesture.center.pageY;
    } else {
      evt_x = event.pageX;
      evt_y = event.pageY;
    }
    return {
      x: evt_x,
      y: evt_y
    };
  };

  return Camera;

})();
