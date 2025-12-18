import { reeler } from "./terminus/reeler.js";
import "./terminus/code_mirror.js";

const Terminus = {
  ...reeler
};

window.Terminus = Terminus;

export { Terminus };
