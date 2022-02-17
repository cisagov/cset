import { ComponentFixture, TestBed } from '@angular/core/testing';

import { QuestionBlockVadrComponent } from './question-block-vadr.component';

describe('QuestionBlockVadrComponent', () => {
  let component: QuestionBlockVadrComponent;
  let fixture: ComponentFixture<QuestionBlockVadrComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ QuestionBlockVadrComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(QuestionBlockVadrComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
