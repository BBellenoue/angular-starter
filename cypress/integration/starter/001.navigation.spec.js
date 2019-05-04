describe('Navigation', function() {
    it('Should visit all pages', function() {
        cy.log('Visit home page')
        cy.visit('/')
        cy.title().should('eq', 'AngularStarter')
    })
})
