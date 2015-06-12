var API = {
  init: function() {
    this.token = localStorage.getItem("token");
    this.dispatcher = new WebSocketRails('localhost:3000/websocket');

    this.user_id = prompt("user_id");

    this.dispatcher.trigger('users.login', {user_id: this.user_id}, this.onLogin);
    this.dispatcher.bind('users.new', this.onUserNew);
    this.dispatcher.bind('duels.challenged', this.onChallenged);
    return this;
  },
  startDuel: function(opponent) {
    this.dispatcher.trigger('duels.start', {user_id: this.user_id, opponent: opponent});
  },
  getDuels: function() {
    this.dispatcher.trigger('duels.index', {user_id: this.user_id}, this.onGetDuels);
  },
  onLogin: function(res) {
    API.token = localStorage.setItem("token", res.token);
    API.dispatcher.trigger('users.index', {}, function(res) {console.log(res.users.length)});
  },
  onUserNew: function(res) {
    console.log("users.new: ", res.users.length);
  },
  onChallenged: function(res) {
    console.log("challenged by: ", res);
  },
  onGetDuels: function(res) {
    console.log("my duels: ", res);
  }

}.init();
