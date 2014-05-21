
public class Neuron {
	private double[] weights;

	public Neuron(int nweights) {
		this.weights = new double[nweights];

		for (int i = 0; i < nweights; i++) {
			this.weights[i] = 2.0*Math.random()-1;
		}
	}

	public double net(double input[]) {
		double sum = 1 * this.weights[0];

		for (int i = 0; i < input.length; i++) {
			sum += input[i] * this.weights[i+1];
		}

		return sum;
	}

	public double activation(double net) {
		return 1.0 / (1.0 + Math.exp(-net));
	}

	public void setWeights(double weights[]) {
		this.weights = weights;
	}

	public double[] getWeights() {
		return this.weights;
	}
}
