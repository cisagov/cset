import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RraAnswerComplianceComponent } from './rra-answer-compliance.component';

describe('RraAnswerComplianceComponent', () => {
  let component: RraAnswerComplianceComponent;
  let fixture: ComponentFixture<RraAnswerComplianceComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RraAnswerComplianceComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RraAnswerComplianceComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
