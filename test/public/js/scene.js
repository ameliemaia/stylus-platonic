var Scene,
  _this = this,
  __slice = [].slice,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

window.log = function() {
  var args;
  args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
  return typeof console !== "undefined" && console !== null ? console.log.apply(console, args) : void 0;
};

Scene = (function() {
  Scene.prototype.view = '';

  Scene.prototype.views = ['polygons', 'primitives', 'platonic-solids', 'fractals', 'ui-components', 'particles'];

  function Scene() {
    this.loop = __bind(this.loop, this);
    this._change_view = __bind(this._change_view, this);
    var cam_settings, i, view, _i, _len, _ref,
      _this = this;
    this.$window = $(window);
    _ref = this.views;
    for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
      view = _ref[i];
      if (window.location.href.match(RegExp("" + view))) {
        this.views.splice(i, 1);
        this.views.unshift(view);
      }
    }
    this.$viewport = $('.platonic-viewport');
    this.$scene = this.$viewport.find('section.scene');
    this.light = new Photon.Light();
    this.face_groups = [];
    $('.group:not([data-light="0"]), .mesh:not(.group > .mesh):not([data-light="0"])').each(function(index, element) {
      var face_group;
      face_group = new Photon.FaceGroup($(element)[0], $(element).find('.face'), 0.8, 0.1, true);
      return _this.face_groups.push(face_group);
    });
    this.cam = new Camera(this.$viewport);
    this.stats = new Stats();
    this.$viewport.append(this.stats.domElement);
    this.gui = new dat.GUI();
    this.gui.add(this, 'view', this.views).onChange(function(value) {
      return _this._change_view(value);
    });
    cam_settings = this.gui.addFolder('Camera');
    cam_settings.add(this.cam, 'perspective', 0, 2000);
    cam_settings.add(this.cam, 'rotate_x').listen();
    cam_settings.add(this.cam, 'rotate_y').listen();
    cam_settings.add(this.cam, 'manual_rotate');
    cam_settings.open();
    this.$window.resize(function() {
      return _this.on_resize();
    });
    this.$window.trigger('resize');
    this.loop();
  }

  Scene.prototype._change_view = function(view) {
    return window.location = "" + window.location.origin + "/" + view + ".html";
  };

  Scene.prototype.on_resize = function() {
    this.win_width = this.$window.width();
    this.win_height = this.$window.height();
    this.$viewport.css({
      height: this.win_height + 'px'
    });
    this.$scene.css({
      height: this.win_height + 'px'
    });
    return this.cam.resize();
  };

  Scene.prototype.update = function() {
    var face_group, _i, _len, _ref;
    this.stats.begin();
    this.cam.update();
    if (this.face_groups.length > 0) {
      _ref = this.face_groups;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        face_group = _ref[_i];
        face_group.render(this.light, true);
      }
    }
    return this.stats.end();
  };

  Scene.prototype.loop = function() {
    this.update();
    return requestAnimationFrame(this.loop);
  };

  return Scene;

})();

$(function() {
  var scene;
  return scene = new Scene();
});
