import Pusher from "pusher-js";

export default new Pusher("edfjk5ffe67926a756t9", {
  channelAuthorization: {
    endpoint: "/authenticate",
    transport: "ajax",
  },
});
