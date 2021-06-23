import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-rra-levels',
  templateUrl: './rra-levels.component.html',
  styleUrls: ['./rra-levels.component.scss', '../../../../reports/reports.scss']
})
export class RraLevelsComponent implements OnInit {

  constructor() { }

  ngOnInit(): void {
  }
 //Pyramid Chart
 getPyramidRowColor(level) {
  let backgroundColor = this.getGradient("blue", .1);
  let textColor = "white";
  return {
    background: backgroundColor,
    color: 'white',
    height: '48px',
    padding: '12px 0'
  };
}

getGradient(color, alpha = 1, reverse = false) {
  let vals = {
    color_one: "",
    color_two: ""
  }
  alpha = 1
  switch (color) {
    case "blue":
    case "blue-1": {
      vals["color_one"] = `rgba(31,82,132,${alpha})`
      vals["color_two"] = `rgba(58,128,194,${alpha})`
      break;
    }
    case "blue-2": {
      vals["color_one"] = `rgba(75,116,156,${alpha})`
      vals["color_two"] = `rgba(97,153,206,${alpha})`
      break;
    }
    case "blue-3": {
      vals["color_one"] = `rgba(120,151,156,${alpha})`
      vals["color_two"] = `rgba(137,179,218,${alpha})`
      break;
    }
    case "blue-4": {
      vals["color_one"] = `rgba(165,185,205,${alpha})`
      vals["color_two"] = `rgba(176,204,230,${alpha})`
      break;
    }
    case "blue-5": {
      vals["color_one"] = `rgba(210,220,230,${alpha})`
      vals["color_two"] = `rgba(216,229,243,${alpha})`
      break;
    }
    case "green": {
      vals["color_one"] = `rgba(98,154,109,${alpha})`
      vals["color_two"] = `rgba(31,77,67,${alpha})`
      break;
    }
    case "grey": {
      vals["color_one"] = `rgba(98,98,98,${alpha})`
      vals["color_two"] = `rgba(120,120,120,${alpha})`
      break;
    }
    case "orange": {
      vals["color_one"] = `rgba(255,190,41,${alpha})`
      vals["color_two"] = `rgba(224,217,98,${alpha})`
      break;
    }
  }
  if (reverse) {
    let tempcolor = vals["color_one"]
    vals["color_one"] = vals["color_two"]
    vals["color_two"] = tempcolor
  }
  return `linear-gradient(5deg,${vals['color_one']} 0%, ${vals['color_two']} 100%)`
}
}
