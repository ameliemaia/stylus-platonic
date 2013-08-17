var PlatonicScene,
  _this = this,
  __slice = [].slice,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

window.log = function() {
  var args;
  args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
  return typeof console !== "undefined" && console !== null ? console.log.apply(console, args) : void 0;
};

PlatonicScene = (function() {
  PlatonicScene.prototype.SCENE_READY_CLASS = 'scene-ready';

  PlatonicScene.prototype.stats = {
    groups: 0,
    meshes: 0,
    faces: 0,
    photon_shaders: 0,
    ui_components: 0
  };

  function PlatonicScene(camera_config) {
    this.camera_config = camera_config != null ? camera_config : {};
    this.loop = __bind(this.loop, this);
    this.add_ui_controls = __bind(this.add_ui_controls, this);
    this.setup = __bind(this.setup, this);
    this.$window = $(window);
    this.$viewport = $('.platonic-viewport');
    this.$scene = this.$viewport.find('.scene');
    this.on = new Object();
    this.on.ready = new signals.Signal();
  }

  PlatonicScene.prototype.setup = function() {
    var cam_settings,
      _this = this;
    this.light = new Photon.Light();
    this.face_groups = [];
    $('[data-light="1"]').each(function(index, element) {
      var face_group;
      face_group = new Photon.FaceGroup($(element)[0], $(element).find('.face'), 0.8, 0.1, true);
      return _this.face_groups.push(face_group);
    });
    this.cam = new Camera(this.$viewport, this.camera_config);
    this.ui = new UserInterface(this.$viewport);
    this.fps = new Stats();
    $('header').append(this.fps.domElement);
    this.stats.groups = $('.group').length;
    this.stats.meshes = $('.mesh').length;
    this.stats.faces = $('.face').length;
    this.stats.photon_shaders = $('.photon-shader').length;
    this.stats.ui_components = $('.ui-component').length;
    this.gui = new dat.GUI();
    window.gui = this.gui;
    this.scene_stats = this.gui.addFolder('Scene');
    this.scene_stats.add(this.stats, 'groups').listen();
    this.scene_stats.add(this.stats, 'meshes').listen();
    this.scene_stats.add(this.stats, 'faces').listen();
    this.scene_stats.add(this.stats, 'photon_shaders').listen();
    this.scene_stats.add(this.stats, 'ui_components').listen();
    cam_settings = this.gui.addFolder('Camera');
    cam_settings.add(this.cam, 'perspective', 0, 2000);
    cam_settings.add(this.cam, 'rotation_x').listen();
    cam_settings.add(this.cam, 'rotation_y').listen();
    cam_settings.add(this.cam, 'reset');
    this.$window.resize(function() {
      return _this.on_resize();
    });
    this.$window.trigger('resize');
    this.$scene.addClass(this.SCENE_READY_CLASS);
    return this.on.ready.dispatch();
  };

  PlatonicScene.prototype.add_ui_controls = function() {
    var ui_settings,
      _this = this;
    ui_settings = this.gui.addFolder('UI');
    ui_settings.add(this.ui, 'grid').onChange(function() {
      return _this.ui.update();
    });
    return ui_settings.add(this.ui, 'display_axis').onChange(function() {
      return _this.ui.update();
    });
  };

  PlatonicScene.prototype.on_resize = function() {
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

  PlatonicScene.prototype.update = function() {
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

  PlatonicScene.prototype.loop = function() {
    this.update();
    return requestAnimationFrame(this.loop);
  };

  return PlatonicScene;

})();
