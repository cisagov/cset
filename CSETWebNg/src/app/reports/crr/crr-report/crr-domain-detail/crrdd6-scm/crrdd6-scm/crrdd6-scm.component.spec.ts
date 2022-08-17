import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Crrdd6ScmComponent } from './crrdd6-scm.component';

describe('Crrdd6ScmComponent', () => {
  let component: Crrdd6ScmComponent;
  let fixture: ComponentFixture<Crrdd6ScmComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ Crrdd6ScmComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(Crrdd6ScmComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
