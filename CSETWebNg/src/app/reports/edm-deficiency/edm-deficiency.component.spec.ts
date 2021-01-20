import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EdmDeficiencyComponent } from './edm-deficiency.component';

describe('EdmDeficiencyComponent', () => {
  let component: EdmDeficiencyComponent;
  let fixture: ComponentFixture<EdmDeficiencyComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EdmDeficiencyComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EdmDeficiencyComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
