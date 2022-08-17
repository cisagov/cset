import { EDMScore } from "./EDMScore";

export interface EdmScoreParent {
    parent: EDMScore;
    children: EDMScore[];
}
