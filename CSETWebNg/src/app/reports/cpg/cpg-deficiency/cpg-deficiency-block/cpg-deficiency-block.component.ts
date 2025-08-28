import { Component, Input } from '@angular/core';
import { QuestionsService } from '../../../../services/questions.service';

@Component({
  selector: 'app-cpg-deficiency-block',
  standalone: false,
  templateUrl: './cpg-deficiency-block.component.html',
  styleUrl: './cpg-deficiency-block.component.scss'
})
export class CpgDeficiencyBlockComponent {

  @Input()
  deficiencyList: any[];

  constructor(
    public questionsSvc: QuestionsService
  ) {}

}
