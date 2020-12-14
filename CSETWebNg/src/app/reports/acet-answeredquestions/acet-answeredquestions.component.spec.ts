import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AcetAnsweredquestionsComponent } from './acet-answeredquestions.component';

describe('AcetAnsweredquestionsComponent', () => {
  let component: AcetAnsweredquestionsComponent;
  let fixture: ComponentFixture<AcetAnsweredquestionsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AcetAnsweredquestionsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AcetAnsweredquestionsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
