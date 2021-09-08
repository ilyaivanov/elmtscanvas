//@ts-expect-error
import { Elm } from "./Main.elm";

var app = Elm.Main.init({
  node: document.getElementById("root"),
});

const ports: ElmPorts = app.ports;

type Rect = {
  x: number;
  y: number;
};

type Subscription<T> = {
  subscribe(cb: (payload: T) => void): void;
};

type ElmPorts = {
  sendMessage: Subscription<Rect>;
};

ports.sendMessage.subscribe(function (rect) {
  const canvas = document.getElementById("rootCanvas") as HTMLCanvasElement;
  const ctx = canvas.getContext("2d")!;
  ctx.lineWidth = 10;
  ctx.fillStyle = "green";
  ctx.clearRect(0, 0, 800, 800);
  ctx.fillRect(rect.x, rect.y, 50, 50);
});
