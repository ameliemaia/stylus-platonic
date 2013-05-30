// Generated by CoffeeScript 1.4.0
var Scene,
  _this = this,
  __slice = [].slice,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

window.log = function() {
  var args;
  args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
  return console.log.apply(console, args);
};

Scene = (function() {

  Scene.prototype.$window = null;

  Scene.prototype.win_width = 0;

  Scene.prototype.win_height = 0;

  Scene.prototype.stats = null;

  Scene.prototype.$viewport = null;

  Scene.prototype.$scene = null;

  Scene.prototype.light = null;

  Scene.prototype.face_groups = Array;

  function Scene() {
    this.loop = __bind(this.loop, this);

    var cam_settings,
      _this = this;
    this.$window = $(window);
    this.$viewport = $('.platonic-viewport');
    this.$scene = this.$viewport.find('section.scene');
    this.light = new Photon.Light();
    this.face_groups = [];
    $('div.mesh-group:not([data-light="0"]), div.mesh:not(div.mesh-group > div.mesh):not([data-light="0"])').each(function(index, element) {
      var face_group;
      face_group = new Photon.FaceGroup($(element)[0], $(element).find('.face'), 0.8, 0.1, true);
      return _this.face_groups.push(face_group);
    });
    this.cam = new Camera(this.$viewport);
    this.stats = new Stats();
    this.$viewport.append(this.stats.domElement);
    this.gui = new dat.GUI();
    cam_settings = this.gui.addFolder('Camera');
    cam_settings.add(this.cam, 'perspective', 0, 2000);
    cam_settings.add(this.cam, 'base_rotation_x');
    cam_settings.add(this.cam, 'base_rotation_y');
    cam_settings.add(this.cam, 'rotate_x');
    cam_settings.add(this.cam, 'rotate_y');
    cam_settings.add(this.cam, 'manual_rotate');
    cam_settings.add(this.cam, 'gimball_radius');
    cam_settings.add(this.cam, 'max_rotation_x');
    cam_settings.add(this.cam, 'max_rotation_y');
    cam_settings.open();
    this.$window.resize(function() {
      return _this.on_resize();
    });
    this.$window.trigger('resize');
    this.loop();
  }

  /*
      Window resize handler
  */


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
    _ref = this.face_groups;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      face_group = _ref[_i];
      face_group.render(this.light, true);
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
