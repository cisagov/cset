import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Crrdd10SaComponent } from './crrdd10-sa.component';

describe('Crrdd10SaComponent', () => {
  let component: Crrdd10SaComponent;
  let fixture: ComponentFixture<Crrdd10SaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ Crrdd10SaComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(Crrdd10SaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
