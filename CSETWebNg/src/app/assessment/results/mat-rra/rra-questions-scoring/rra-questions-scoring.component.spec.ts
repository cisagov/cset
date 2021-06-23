import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RraQuestionsScoringComponent } from './rra-questions-scoring.component';

describe('RraQuestionsScoringComponent', () => {
  let component: RraQuestionsScoringComponent;
  let fixture: ComponentFixture<RraQuestionsScoringComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RraQuestionsScoringComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RraQuestionsScoringComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
