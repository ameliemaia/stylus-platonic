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
  Scene.prototype.stats = {
    groups: 0,
    meshes: 0,
    faces: 0,
    photon_shaders: 0,
    ui_components: 0
  };

  function Scene() {
    this.loop = __bind(this.loop, this);
    var cam_settings, scene_stats,
      _this = this;
    this.$window = $(window);
    this.$viewport = $('.platonic-viewport');
    this.$scene = this.$viewport.find('.scene');
    this.light = new Photon.Light();
    this.face_groups = [];
    $('[data-light="1"]').each(function(index, element) {
      var face_group;
      face_group = new Photon.FaceGroup($(element)[0], $(element).find('.face'), 0.8, 0.1, true);
      return _this.face_groups.push(face_group);
    });
    this.cam = new Camera(this.$viewport);
    this.fps = new Stats();
    this.$viewport.append(this.fps.domElement);
    this.stats.groups = $('.group').length;
    this.stats.meshes = $('.mesh').length;
    this.stats.faces = $('.face').length;
    this.stats.photon_shaders = $('.photon-shader').length;
    this.stats.ui_components = $('.ui-component').length;
    this.gui = new dat.GUI();
    window.gui = this.gui;
    scene_stats = this.gui.addFolder('Scene');
    scene_stats.add(this.stats, 'groups').listen();
    scene_stats.add(this.stats, 'meshes').listen();
    scene_stats.add(this.stats, 'faces').listen();
    scene_stats.add(this.stats, 'photon_shaders').listen();
    scene_stats.add(this.stats, 'ui_components').listen();
    cam_settings = this.gui.addFolder('Camera');
    cam_settings.add(this.cam, 'perspective', 0, 2000);
    cam_settings.add(this.cam, 'rotation_x').listen();
    cam_settings.add(this.cam, 'rotation_y').listen();
    cam_settings.add(this.cam, 'reset');
    this.$window.resize(function() {
      return _this.on_resize();
    });
    this.$window.trigger('resize');
    this.loop();
  }

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
    this.fps.begin();
    this.cam.update();
    if (this.face_groups.length > 0) {
      _ref = this.face_groups;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        face_group = _ref[_i];
        face_group.render(this.light, true);
      }
    }
    return this.fps.end();
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
