require "rails_helper"

RSpec.describe PokemonsRepository do
  subject { described_class.new(datasource_path: path) }

  let(:path) { Rails.root.join("data/pokemons.csv") }

  before(:each) do
    FileUtils.cp(
      Rails.root.join("data/pokemons.original.csv"),
      Rails.root.join("data/pokemons.csv")
    )
  end

  context "with a valid datasource path" do
    describe "#all" do
      it "return every lines" do
        expect(subject.all.size).to eql(800)
      end

      it "return Pokemon objects" do
        expect(subject.all.first).to be_an_instance_of(Pokemon)
      end
    end

    describe "#find_by" do
      context "with valid attributes" do
        let(:attributes) { { id: 6 } }

        it "must return all results" do
          expect(subject.find_by(attributes: attributes).size).to eql(3)
        end

        context "with many attributes" do
          let(:attributes) { { id: 6, name: "CharizardMega Charizard Y" } }

          it "must return all results" do
            expect(subject.find_by(attributes: attributes).size).to eql(1)
            expect(subject.find_by(attributes: attributes).first.type_2).to eql("Flying")
          end
        end
      end

      context "with invalid attributes" do
        let(:attributes) { { foo: 1, bar: 2 } }

        it "must return an empty array" do
          expect(subject.find_by(attributes: attributes)).to eql([])
        end
      end
    end

    describe "#insert" do
      context "with valid object" do
        let(:pokemon) do
          Pokemon.new(
            id: 722,
            name: "Martin",
            type_1: "Air",
            type_2: "Ground",
            total: 600,
            hp: 80,
            attack: 100,
            defense: 200,
            sp_atk: 50,
            sp_def: 100,
            speed: 30,
            generation: 8,
            legendary: true
          )
        end

        it "must write the new object at the end of the datasource" do
          subject.insert(pokemon)
          expect(subject.all.size).to eql(801)
        end
      end

      context "with invalid object" do
        let(:pokemon) { { foo: 1, bar: 2 } }

        it "must not write the new object at the end of the datasource" do
          subject.insert(pokemon)
          expect(subject.all.size).to eql(800)
        end
      end
    end

    describe "#update" do
      context "with a valid id" do
        let(:finding_attributes) { { id: 6 } } # this id returns several results

        context "with valid attributes to update" do
          let(:update_attributes) { { id: 666, name: "Terminator" } }

          it "must update every object with given attributes" do
            subject.update(finding_attributes: finding_attributes, update_attributes: update_attributes)
            subject.reload
            expect(subject.find_by(attributes: update_attributes).size).to eql(3)
          end
        end
      end
    end

    describe "#delete" do
      context "when returning several results" do
        let(:attributes) { { id: 6 } }

        it "must delete every objects" do
          subject.delete(attributes: attributes)
          expect(subject.find_by(attributes: attributes).size).to eql(0)
        end
      end
    end
  end

  context "with a wrong datasource path" do
    let(:path) { Rails.root.join("data/teletubbies.csv") }

    it "must raise an exception" do
      expect { subject }.to raise_exception(Errno::ENOENT)
    end
  end
end
